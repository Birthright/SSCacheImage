//
//  SSCacheImageViewAppDelegate.h
//  SSCacheImageView
//
//  Created by wen yu on 11-7-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSCacheImageViewViewController;

@interface SSCacheImageViewAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet SSCacheImageViewViewController *viewController;

@end
