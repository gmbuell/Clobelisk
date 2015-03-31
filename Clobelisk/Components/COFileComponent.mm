#import "COFileComponent.h"

#import "COFile.h"

@implementation COFileComponent

+ (instancetype)newWithCOFile:(COFile *)file
{
  return [super newWithComponent:cofileComponent(file)];
}

static CKComponent *cofileComponent(COFile *file)
{
  return [CKStackLayoutComponent
           newWithView:{}
 size:{}
 style:{}
 children:{
      {
      [CKLabelComponent
        newWithLabelAttributes:{
          .string = file.text,
              .font = [UIFont fontWithName:@"Baskerville" size:30]
        }
     viewAttributes:{
          {@selector(setBackgroundColor:), [UIColor clearColor]},
          {@selector(setUserInteractionEnabled:), @NO},
        }
       ],
          .alignSelf = CKStackLayoutAlignSelfCenter
          },
      {
      [CKLabelComponent
        newWithLabelAttributes:{
          .string = file.author,
              .font = [UIFont fontWithName:@"Verdana" size:20]
        }
     viewAttributes:{
          {@selector(setBackgroundColor:), [UIColor clearColor]},
          {@selector(setUserInteractionEnabled:), @NO},
        }
       ],
          .alignSelf = CKStackLayoutAlignSelfEnd
          }
    }
          ]
}
