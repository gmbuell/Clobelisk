#import "CKCompositeComponent.h"

@class COFile;

/**
 A VideoComponent formats video metadata.
 */
@interface COFileComponent : CKCompositeComponent

+ (instancetype)newWithCOFile:(COFile *)file context:(NSObject *)context;

@end
