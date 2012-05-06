#import <Foundation/Foundation.h>

#define TCMakeTypeSafe(klass) @class klass; @protocol klass \
/*Generic*/\
- (klass*)typedObject; \
- (void)setTypedObject:(klass*)obj; \
\
/*NSArray*/\
- (klass*)typedObjectAtIndex:(NSUInteger)index; \
- (BOOL)containsTypedObject:(klass*)anObject; \
- (klass*)lastTypedObject; \
\
/*NSMutableArray*/\
- (void)insertTypedObject:(klass*)thing atIndex:(NSUInteger)idx; \
- (void)addTypedObject:(klass*)thing; \
\
/*NSDictionary*/\
- (klass*)typedObjectForKey:(id)aKey; \
- (NSArray<klass> *)allTypedValues; \
\
/*NSMutableDictionary*/\
- (void)setTypedObject:(klass*)anObject forKey:(id <NSCopying>)aKey; \
\
@end