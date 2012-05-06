#import <Foundation/Foundation.h>
#import "TCTypeSafety.h"

@interface MyThing : NSObject
@end
TCMakeTypeSafe(MyThing);


// Example generic fake future
@interface TCFuture : NSObject
@property(strong) id value;
@end


@interface MyThingFactory : NSObject
- (TCFuture<MyThing> *)fetchLatestThing;
@end

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        MyThingFactory *fac = [MyThingFactory new];
        MyThing *thing = [fac fetchLatestThing].typedObject;
        
        NSMutableArray<MyThing> *typedArray = (id)[NSMutableArray new];
        
        [typedArray insertTypedObject:thing atIndex:0];
        
        NSLog(@"Typed things: %@", typedArray);
    }
    return 0;
}



@implementation MyThing;
@end
@implementation MyThingFactory
- (TCFuture<MyThing> *)fetchLatestThing;
{
    TCFuture<MyThing> *task = (id)[TCFuture new];
    task.typedObject = [MyThing new];
    return task;
}
@end
@implementation TCFuture
@synthesize value = _value;

// Adding support for type safety
- (id)typedObject;
{
    return (id)self.value;
}
- (void)setTypedObject:(id)obj;
{
    self.value = obj;
}
@end
