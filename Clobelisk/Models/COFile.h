#import <Foundation/Foundation.h>

@interface COFile : NSObject

@property (nonatomic, readonly, copy) NSString *text;
@property (nonatomic, copy) NSString *video_path;
@property (nonatomic, copy) NSString *image_path;

- (instancetype)initWithText:(NSString *)text;

@end
