//
//  ClobeliskCollectionViewController.m
//  Clobelisk
//
//  Created by Garret Buell on 3/30/15.
//  Copyright (c) 2015 Garret Buell. All rights reserved.
//

#import "ClobeliskCollectionViewController.h"

#import <ComponentKit/CKComponentProvider.h>
#import <ComponentKit/CKCollectionViewDataSource.h>
#import <ComponentKit/CKArrayControllerChangeset.h>
#import <ComponentKit/CKComponentFlexibleSizeRangeProvider.h>

@interface ClobeliskCollectionViewController () <CKComponentProvider, UIScrollViewDelegate>
@end

@implementation ClobeliskCollectionViewController {
    CKCollectionViewDataSource *_dataSource;
    // QuoteModelController *_quoteModelController;
    CKComponentFlexibleSizeRangeProvider *_sizeRangeProvider;
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithCollectionViewLayout:layout]) {
        _sizeRangeProvider = [CKComponentFlexibleSizeRangeProvider providerWithFlexibility:CKComponentSizeRangeFlexibleHeight];
        // _quoteModelController = [[QuoteModelController alloc] init];
        self.title = @"Wilde Guess";
        self.navigationItem.prompt = @"Tap to reveal which quotes are from Oscar Wilde";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Preload images for the component context that need to be used in component preparation. Components preparation
    // happens on background threads but +[UIImage imageNamed:] is not thread safe and needs to be called on the main
    // thread. The preloaded images are then cached on the component context for use inside components.
    NSSet *imageNames = [NSSet setWithObjects:
                         @"LosAngeles",
                         @"MarketStreet",
                         @"Drops",
                         @"Powell",
                         nil];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    
    // QuoteContext *context = [[QuoteContext alloc] initWithImageNames:imageNames];
    NSMutableArray *context = [[NSMutableArray alloc] init];
    _dataSource = [[CKCollectionViewDataSource alloc] initWithCollectionView:self.collectionView
                                                 supplementaryViewDataSource:nil
                                                           componentProvider:[self class]
                                                                     context:context
                                                   cellConfigurationFunction:nil];
    // Insert the initial section
    CKArrayControllerSections sections;
    sections.insert(0);
    [_dataSource enqueueChangeset:{sections, {}} constrainedSize:{}];
    // [self _enqueuePage:[_quoteModelController fetchNewQuotesPageWithCount:4]];
}

#pragma mark - UICollectionViewFlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [_dataSource sizeForItemAtIndexPath:indexPath];
}

#pragma mark - CKComponentProvider

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrolledToBottomWithBuffer(scrollView.contentOffset, scrollView.contentSize, scrollView.contentInset, scrollView.bounds)) {
        // [self _enqueuePage:[_quoteModelController fetchNewQuotesPageWithCount:8]];
    }
}

static BOOL scrolledToBottomWithBuffer(CGPoint contentOffset, CGSize contentSize, UIEdgeInsets contentInset, CGRect bounds)
{
    CGFloat buffer = CGRectGetHeight(bounds) - contentInset.top - contentInset.bottom;
    const CGFloat maxVisibleY = (contentOffset.y + bounds.size.height);
    const CGFloat actualMaxY = (contentSize.height + contentInset.bottom);
    return ((maxVisibleY + buffer) >= actualMaxY);
}

@end