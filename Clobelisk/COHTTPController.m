//
//  COHTTPController.m
//  Clobelisk
//
//  Created by Garret Buell on 4/4/15.
//  Copyright (c) 2015 Garret Buell. All rights reserved.
//

#import "COHTTPController.h"

#import <Foundation/Foundation.h>
#import <PromiseKit.h>
#import <AFNetworking+PromiseKit.h>
#import <TFHpple.h>
#import <Underscore.h>

#import "COFile.h"

@implementation COHTTPController {
    NSArray *_fileList;
}

- (PMKPromise *)fetchFiles {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        if (_fileList) {
            NSLog(@"Returning cached file list.");
            fulfill(_fileList);
        }

        [AFHTTPRequestOperation request:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.39/Movies/"]]].then(^(id responseObject){
            TFHpple *doc = [[TFHpple alloc] initWithHTMLData:responseObject];
            NSArray *elements = [doc searchWithXPathQuery:@"//a"];
            
            _fileList = Underscore.array(elements)
            .reject(^BOOL (TFHppleElement *e) {
                return [[e text] isEqualToString:@"../"];
            }).map(^NSString *(TFHppleElement *e) {
                return [[e text] stringByReplacingOccurrencesOfString:@"/" withString:@""];
            }).unwrap;
            
            NSLog(@"Returning fresh file list.");
            fulfill(_fileList);
        }).catch(^(NSError *error){
            NSLog(@"error: %@", error.localizedDescription);
            NSLog(@"original operation: %@", error.userInfo[AFHTTPRequestOperationErrorKey]);
            reject(error);
        });
    }];
}

@end
