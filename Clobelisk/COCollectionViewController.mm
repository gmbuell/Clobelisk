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
#import <AFNetworking+PromiseKit.h>

#import "COFile.h"
#import "COFileComponent.h"

@interface COCollectionViewController () <CKComponentProvider, UIScrollViewDelegate>
@end

@implementation COCollectionViewController {
    CKCollectionViewDataSource *_dataSource;
    // QuoteModelController *_quoteModelController;
    CKComponentFlexibleSizeRangeProvider *_sizeRangeProvider;
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithCollectionViewLayout:layout]) {
        _sizeRangeProvider = [CKComponentFlexibleSizeRangeProvider providerWithFlexibility:CKComponentSizeRangeFlexibleHeight];
        // _quoteModelController = [[QuoteModelController alloc] init];
        self.title = @"Clobelisk";
        self.navigationItem.prompt = @"Hello";
    }
    return self;
}

static NSArray *cofileList()
{
  static NSArray *files;
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    files = @[
               @{
                 @"text": @"I have the simplest tastes. I am always satisfied with the best.",
                 @"author": @"Oscar Wilde",
                 },
               @{
                 @"text": @"A thing is not necessarily true because a man dies for it.",
                 @"author": @"Oscar Wilde",
                 },
               @{
                 @"text": @"A poet can survive everything but a misprint.",
                 @"author": @"Oscar Wilde",
                 },
               @{
                 @"text": @"He is really not so ugly after all, provided, of course, that one shuts one's eyes, and does not look at him.",
                 @"author": @"Oscar Wilde",
                 }
               ];
  });
  return files;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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

    // Insert some sample items.
    CKArrayControllerInputItems items;
    items.insert({0, 0}, [[COFile alloc] initWithText:@"I have the simplest tastes. I am always satisfied with the best." author:@"Oscar Wilde"]);
    [_dataSource enqueueChangeset:{{}, items}
                  constrainedSize:[_sizeRangeProvider sizeRangeForBoundingSize:self.collectionView.bounds.size]];
    
    [AFHTTPRequestOperation request:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://obelisk/"]]].then(^(id responseObject){
        NSLog(@"operation completed! %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
    }).catchOn(dispatch_get_main_queue(), ^(NSError *error){
        NSLog(@"error: %@", error.localizedDescription);
        NSLog(@"original operation: %@", error.userInfo[AFHTTPRequestOperationErrorKey]);
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
  return [COFileComponent
          newWithCOFile:file];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

@end
