//
//  COHTTPController.h
//  Clobelisk
//
//  Created by Garret Buell on 4/4/15.
//  Copyright (c) 2015 Garret Buell. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PMKPromise;

@interface COHTTPController : NSObject

- (PMKPromise *)fetchFiles;

@end
