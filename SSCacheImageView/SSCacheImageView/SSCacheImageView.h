//
//  SSCacheImageView.h
//  SSCacheImageView
//
//  Created by wen yu on 11-6-20.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSCacheImageView : UIImageView {
    NSURLConnection *connection;
    NSMutableData   *data;
    BOOL showAIView;
    UIActivityIndicatorView *aiView;
    BOOL autoResizeEnabled;
    NSURL *currentUrl;
    NSString *cachePath;
    NSString *cacheFloder;
    //是否更新缓存
    BOOL updateCacheEnabled;
}
//显示菊花
@property (nonatomic,assign) BOOL showAIView;
//尺寸自动调整
@property (nonatomic,assign) BOOL autoResizeEnabled;
//缓存
@property (nonatomic,assign) BOOL updateCacheEnabled;
//缓存路径,路径优先
@property (nonatomic,assign) NSString *cachePath;
//缓存目录
@property (nonatomic,assign) NSString *cacheFloder;

//2011/07/21 add
//清除所有缓存的图片
+ (void)clearALLCachedImage;
//按时间清除缓存图片
+ (void)clearCachedImageBefore:(NSDate*)date;
+ (void)clearCachedImageFrom:(NSDate*)startDate toDate:(NSDate*)endDate;
+ (void)setAutoClearRules:(int)cacheDays cacheMaxSize:(long)mb;
+ (void)autoClear;
+ (void)showRules;

//old method before 2011.07.21
- (void)loadImageFromURL:(NSURL*)url;
- (BOOL)loadFromLocal:(NSURL*)url;
- (NSString*)randomName;
- (NSDictionary*)savedDict;
- (void)saveDict:(NSMutableDictionary*)dict;
- (void)addImageFile;


@end
