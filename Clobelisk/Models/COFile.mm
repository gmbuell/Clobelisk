#import "COFile.h"

@implementation COFile

- (instancetype)initWithText:(NSString *)text
                      author:(NSString *)author
{
  if (self = [super init]) {
    _text = [text copy];
    _author = [author copy];
  }
  return self;
}

@end
