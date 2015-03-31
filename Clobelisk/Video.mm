#import "Video.h"

@implementation Video

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
