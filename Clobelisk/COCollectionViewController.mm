//
//  ClobeliskCollectionViewController.m
//  Clobelisk
//
//  Created by Garret Buell on 3/30/15.
//  Copyright (c) 2015 Garret Buell. All rights reserved.
//

#import "COCollectionViewController.h"

#import <Foundation/Foundation.h>
#import <ComponentKit/CKComponentProvider.h>
#import <ComponentKit/CKCollectionViewDataSource.h>
#import <ComponentKit/CKArrayControllerChangeset.h>
#import <ComponentKit/CKComponentFlexibleSizeRangeProvider.h>
#import <PromiseKit.h>
#import <Underscore.h>

#import "COFile.h"
#import "COFileComponent.h"
#import "COHTTPController.h"
#import "ChromecastDeviceController.h"

@interface COCollectionViewController () <CKComponentProvider, UIScrollViewDelegate, UICollectionViewDelegate>
@end

@implementation COCollectionViewController {
    CKCollectionViewDataSource *_dataSource;
    CKComponentFlexibleSizeRangeProvider *_sizeRangeProvider;
    COHTTPController *_http_controller;
    ChromecastDeviceController *_chromecast_controller;
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithCollectionViewLayout:layout]) {
        _sizeRangeProvider = [CKComponentFlexibleSizeRangeProvider providerWithFlexibility:CKComponentSizeRangeFlexibleHeight];
        // _quoteModelController = [[QuoteModelController alloc] init];
        self.title = @"Clobelisk";
        self.navigationItem.prompt = @"Hello";
    }
    
    _http_controller = [[COHTTPController alloc] init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _chromecast_controller = [[ChromecastDeviceController alloc] initWithView:super.collectionView];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    
    _dataSource = [[CKCollectionViewDataSource alloc] initWithCollectionView:self.collectionView
                                                 supplementaryViewDataSource:nil
                                                           componentProvider:[self class]
                                                                     context:nil
                                                   cellConfigurationFunction:nil];
    // Insert the initial section
    CKArrayControllerSections sections;
    sections.insert(0);
    [_dataSource enqueueChangeset:{sections, {}} constrainedSize:{}];
    
    [_http_controller fetchFiles].then(^(NSArray *fileNames) {
        CKArrayControllerInputItems items;
        for (NSInteger i = 0; i < [fileNames count]; i++) {
            items.insert([NSIndexPath indexPathForRow:i inSection:0], [[COFile alloc] initWithText:fileNames[i]]);
        }
        [_dataSource enqueueChangeset:{{}, items}
                      constrainedSize:[_sizeRangeProvider sizeRangeForBoundingSize:self.collectionView.bounds.size]];
    });
}


#pragma mark - UICollectionViewFlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [_dataSource sizeForItemAtIndexPath:indexPath];
}

#pragma mark - CKComponentProvider

+ (CKComponent *)componentForModel:(COFile *)file context:(NSObject *)context
{
    return [COFileComponent newWithCOFile:file context:context];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    COFile *file = (COFile *)[_dataSource modelForItemAtIndexPath:indexPath];
    NSLog(@"%@", file.text);
    [_http_controller fetchDirectory:file.text].then(^(NSArray *directoryContents) {
        for (NSString *dir in directoryContents) {
            NSLog(@"%@", dir);
        }
        // Set video path to the first mp4
        NSArray *mp4s = Underscore.array(directoryContents).filter(^BOOL (NSString *item) {
            return [item hasSuffix:@".mp4"];
        }).unwrap;
        
        BOOL has_landscape = Underscore.array(directoryContents).any(^BOOL (NSString *item) {
            return [item isEqualToString:@"landscape.jpg"];
        });
        
        if ([mp4s count] > 0) {
            file.video_path = [[NSString stringWithFormat:@"http://192.168.1.39/Movies/%@/%@", file.text, mp4s[0]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            if (has_landscape) {
                file.image_path = [[NSString stringWithFormat:@"http://192.168.1.39/Movies/%@/landscape.jpg", file.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            } else {
                NSArray *fanart = Underscore.array(directoryContents).filter(^BOOL (NSString *item) {
                    return [item hasSuffix:@"fanart.jpg"];
                }).unwrap;
                if ([fanart count] > 0) {
                   file.image_path = [[NSString stringWithFormat:@"http://192.168.1.39/Movies/%@/%@", file.text, fanart[0]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                }
            }
            [_chromecast_controller chooseDeviceForFile:file];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                            message:[NSString stringWithFormat:@"No mp4 for %@", file.text]
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                  otherButtonTitles:nil];
            [alert show];
        }
    });
}

@end
