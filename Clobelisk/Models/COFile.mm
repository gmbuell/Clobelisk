#import "COFile.h"

@implementation COFile

- (instancetype)initWithText:(NSString *)text
{
  if (self = [super init]) {
    _text = [text copy];
  }
  return self;
}

@end
