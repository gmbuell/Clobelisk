#import "COFileComponent.h"

#import "COFile.h"

@implementation COFileComponent

+ (instancetype)newWithCOFile:(COFile *)file
{
  return [super newWithComponent:cofileComponent(file)];
}

static CKComponent *cofileComponent(COFile *file)
{
}
