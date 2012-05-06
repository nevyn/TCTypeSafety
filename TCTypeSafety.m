#import "TCTypeSafety.h"


@implementation NSArray (SPTypeSafety)
- (id)typedObjectAtIndex:(NSUInteger)index;
{
    return [self objectAtIndex:index];
}
- (BOOL)containsTypedObject:(id)anObject;
{
    return [self containsObject:anObject];
}
- (id)lastTypedObject;
{
    return [self lastObject];
}
@end

@implementation NSMutableArray (SPTypeSafety)
- (void)insertTypedObject:(id)obj atIndex:(NSUInteger)index;
{
    [self insertObject:obj atIndex:index];
}
- (void)addTypedObject:(id)thing;
{
    [self addObject:thing];
}
@end

@implementation NSDictionary (SPTypeSafety)
- (id)typedObjectForKey:(id)aKey;
{
    return [self objectForKey:aKey];
}
- (NSArray *)allTypedValues;
{
    return [self allValues];
}
@end

@implementation NSMutableDictionary (SPTypeSafety)
- (void)setTypedObject:(id)anObject forKey:(id <NSCopying>)aKey;
{
    [self setObject:anObject forKey:aKey];
}
@end