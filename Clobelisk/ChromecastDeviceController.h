//
//  ChromecastDeviceController.h
//  Clobelisk
//
//  Created by Garret Buell on 4/5/15.
//  Copyright (c) 2015 Garret Buell. All rights reserved.
//

// Copyright 2014 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import <UIKit/UIKit.h>

@class COFile;

/**
 * Controller for managing the Chromecast device. Provides methods to connect to
 * the device, launch an application, load media and control its playback.
 */
@interface ChromecastDeviceController : NSObject
- (void)chooseDeviceForFile:(COFile *)file;

- (instancetype)initWithView:(UIView *)view;
@end
