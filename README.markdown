TCTypeSafety
============
by [Joachim Bengtsson](mailto:joachimb@gmail.com), 20120506

If you have every touched C++, Java or C# and then moved to Objective-C, you have at some point written one of the following in a source file:

<pre><code>NSArray/*&lt;MyThing&gt;*/ *_queuedThings;
NSDictionary *_thingMap; // contains MyThing
-(MAFuture*)fetchThing; // wraps a MyThing
</code></pre>

With <code>TCTypeSafety</code>, you can write pretend that you're writing in a language with generics and write:

<pre><code>@interface MyThing : NSObject
...
@end
TCMakeTypeSafe(MyThing)

(later...)
NSArray&lt;MyThing&gt; _queuedThings;</code></pre>

Why?!
------

Assume that we have some kind of <code>Future</code> class. Assume also that we have a factory that returns <code>Future</code>s that wrap the asynchronous creation of a <code>MyThing</code>. We might want to define the interface for such a factory like this:

<pre><code>@interface MyThingFactory : NSObject
- (TCFuture&lt;MyThing&gt; *)fetchLatestThing;
@end
</code></pre>

Later, when we use the factory:
<pre><code>MyThingFactory *fac = [MyThingFactory new];
NSString *thing = [fac fetchLatestThing].typedObject;
</code></pre>

... actually generates a compiler warning, since <code>typedObject</code> returns <code>MyThing</code>, not <code>NSString</code>. (Note that we did not have to give <code>TCFuture</code> knowledge of the <code>MyThing</code> type to get this benefit, or modify it in any way except make it <code>TCTypeSafety</code> compatible).

This way, we can ensure that even though we have wrapped our <code>MyThing</code>s in a <code>TCFuture</code>, we haven't thrown away type safety, so that if we want to change the return type of <code>fetchLatestThing</code>, we can just do so in the header and then fix all the compiler warnings, rather than going through every single usage of <code>fetchLatestThing</code> and fix any now invalid assumptions on the return type.

This is also useful for collections such as arrays and dictionaries:

<pre><code>NSMutableArray&lt;MyThing&gt; *typedArray = (id)[NSMutableArray new];
[typedArray insertTypedObject:@"Not a MyThing" atIndex:0]; // compiler warning! NSString ≠ MyThing
NSNumber *last = typedArray.lastTypedObject; // compiler warning! NSNumber ≠ MyThing
NSLog(@"Last typed thing: %@", last);
</code></pre>


What?!
--------

The syntax for indicating protocol conformance of a variable is the same that you would use for template/generics specialization in other language. Also, the namespace for protocols is separate from the namespace for classes, so we can have a protocol with the same name as a class. So if we implement a protocol with getters and setters that take and return the type that we are interested in, we can get type safety. For example, we can create the protocol <code>MyThing</code> as such:

<code><pre>@protocol MyThing
- (MyThing*)typedObjectAtIndex:(NSUInteger)index;
- (void)addTypedObject:(MyThing*)thing;
@end</pre></code>

We then need to add support for these methods to <code>NSArray</code> and <code>NSMutableArray</code>. However, the type we are specializing on is only a compile time hint and does not affect the type of the instance, so in the implementation, we can just say that these return 'id'.

<code><pre>@implementation NSArray (SPTypeSafety)
- (id)typedObjectAtIndex:(NSUInteger)index;
{
    return [self objectAtIndex:index];
}
@end

@implementation NSMutableArray (SPTypeSafety)
- (void)addTypedObject:(id)thing;
{
    [self addObject:thing];
}
@end</pre></code>

Tada! Instant type safety.

There must be downsides.
------------------------

Absolutely. You can only "specialize" on a single class: you can't create some generic facility that would let you specialize both the key and the value of an NSDictionary. You have to use weird selectors such as <code>-[NSArray typedObjectAtIndex:]</code>, since the protocol conformance sadly does not override the method signature for your array instance, and using <code>-[NSArray objectAtIndex:]</code> will still give you type-unsafe return values.

Worst of all, by applying the <code>TCMakeTypeSafe</code> macro on your class, it will suddenly look like it has the interface of both a to-one accessor, <code>NSArray</code>, <code>NSDictionary</code>, and whatever else you add support for in <code>TCMakeTypeSafe</code>. Thus, you wouldn't get compile time warnings if you changed your <code>NSArray</code> into an <code>NSDictionary</code>, as you normally would. I _think_ this trade-off is worth it, but I'm not sure.