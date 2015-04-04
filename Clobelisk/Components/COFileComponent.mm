#import "COFileComponent.h"

#import "COFile.h"

#import <ComponentKit/CKStackLayoutComponent.h>
#import <ComponentKit/CKLabelComponent.h>
#import <ComponentKit/CKComponentGestureActions.h>
#import <ComponentKit/CKInsetComponent.h>
#import <ComponentKit/CKComponentScope.h>

@implementation COFileComponent {
    NSString *_fileName;
}

+ (instancetype)newWithCOFile:(COFile *)file
{
    COFileComponent *component = [super newWithComponent:cofileComponent(file)];
    component->_fileName = file.text;
    return component;
}

static CKComponent *cofileComponent(COFile *file)
{
    return [CKStackLayoutComponent
            newWithView:{
                [UIView class],
                {CKComponentTapGestureAttribute(@selector(didTap))}
            }
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

- (void)didTap
{
    NSLog(@"Tapped %@", _fileName);
}

@end