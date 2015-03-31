#import <Foundation/Foundation.h>

@interface COFile : NSObject

@property (nonatomic, readonly, copy) NSString *text;
@property (nonatomic, readonly, copy) NSString *author;

- (instancetype)initWithText:(NSString *)text
                      author:(NSString *)author;

@end
