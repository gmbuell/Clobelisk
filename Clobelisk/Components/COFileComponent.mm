#import "COFileComponent.h"

#import "COFile.h"

#import <ComponentKit/CKStackLayoutComponent.h>
#import <ComponentKit/CKLabelComponent.h>
#import <ComponentKit/CKComponentGestureActions.h>
#import <ComponentKit/CKInsetComponent.h>
#import <ComponentKit/CKComponentScope.h>

@implementation COFileComponent

+ (instancetype)newWithCOFile:(COFile *)file context:(NSObject *)context
{
    return [super newWithComponent:cofileComponent(file)];
}

static CKComponent *cofileComponent(COFile *file)
{
    return [CKStackLayoutComponent
            newWithView:{}
            size:{}
            style:{
                .alignItems = CKStackLayoutAlignItemsStretch
            }
            children:{
                {[CKInsetComponent
                  newWithInsets:{.top = 30, .left = 15, .bottom = 30, .right = 15}
                  component:[CKLabelComponent
                             newWithLabelAttributes:{
                                 .string = file.text,
                                 .font = [UIFont fontWithName:@"Avenir" size:16]
                             }
                             viewAttributes:{
                                 {@selector(setBackgroundColor:), [UIColor clearColor]},
                                 {@selector(setUserInteractionEnabled:), @NO},
                             }
                             ]]},
                {hairlineComponent()}
            }];
}

static CKComponent *hairlineComponent()
{
    return [CKComponent
            newWithView:{
                [UIView class],
                {{@selector(setBackgroundColor:), [UIColor lightGrayColor]}}
            }
            size:{.height = 1/[UIScreen mainScreen].scale}];
}

@end