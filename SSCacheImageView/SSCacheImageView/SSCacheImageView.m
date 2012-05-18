//
//  SSCacheImageView.m
//  SSCacheImageView
//
//  Created by wen yu on 11-6-20.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SSCacheImageView.h"


@implementation SSCacheImageView
@synthesize showAIView;
@synthesize autoResizeEnabled;
@synthesize updateCacheEnabled;
@synthesize cacheFloder;
@synthesize cachePath;

- (id)init{
    self = [super init];
    if (self) { 
        //default background color;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //default background color;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    if (aiView!=nil) {
        [aiView setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    }
}

- (void)loadImageFromURL:(NSURL*)url {
    currentUrl = [url retain];
    if (aiView==nil) {
        aiView = [[UIActivityIndicatorView alloc]init];
        [aiView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [aiView setFrame:CGRectMake(0, 0, 21, 21)];
        [aiView setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
        [self addSubview:aiView];
    }
    [aiView startAnimating];
    
    if ([self loadFromLocal:url]) {
        return;
    }
    
    if (connection!=nil) {
        [connection release];
    }
    
    if (data != nil) {
        [data release];
    }
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:60.0];
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self];

}

- (NSDictionary*)savedDict{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"ssimagecache"];
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
        return [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return nil;
}

- (void)saveDict:(NSMutableDictionary*)dict{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"ssimagecache"];
    [dict writeToFile:path atomically:YES];
}

- (void)addImageFile{
    NSMutableDictionary *dict;
    
    if ([self savedDict]!=nil) {
        NSString *imagePath = [[self savedDict] objectForKey:[currentUrl absoluteString]];
        if (imagePath!=nil) {
            
        }else{
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            imagePath = [documentsDirectory stringByAppendingPathComponent:[self randomName]];
        }
       // NSLog(@"%@",imagePath);
        [data writeToFile:imagePath atomically:YES];
        dict = [[[NSMutableDictionary alloc]initWithDictionary:[self savedDict]] autorelease];
        [dict setObject:imagePath forKey:[currentUrl absoluteString]];
        [self saveDict:dict];
    }else{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[self randomName]];
        [data writeToFile:imagePath atomically:YES];
        dict = [[[NSMutableDictionary alloc]init] autorelease];
        [dict setObject:imagePath forKey:[currentUrl absoluteString]];
        [self saveDict:dict];
    }
    
}

- (NSString*)randomName{
    NSDate *date = [[NSDate alloc]init];
    NSDateFormatter *fat = [[NSDateFormatter alloc]init];
    [fat setDateFormat:@"yyyyMMddHHmmss"];    
    NSString *dateString =  [fat stringFromDate:date];
    
    int number = arc4random() % 899 +100;
    NSString *string = [[NSString alloc] initWithFormat:@"%d",number]; 
    //NSLog(@"%@",string);
    
    NSMutableString *randomName = [NSMutableString stringWithString:dateString];
    [randomName appendString:string];
    
    [date release];
    [fat release];
    [string release];
    
    return randomName;
}

- (BOOL)loadFromLocal:(NSURL*)url{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"ssimagecache"];
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:path]) {
        return NO;
    }
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *imagePath = [dict objectForKey:[url absoluteString]];
    if (imagePath!=nil) {
//        NSLog(@"%@",imagePath);
//        if ([[NSFileManager defaultManager]fileExistsAtPath:imagePath]) {
//            NSLog(@"11");
//        }
        
        data = [[NSData alloc]initWithContentsOfFile:imagePath];
        [self setImage:[UIImage imageWithData:data]];
        [self setNeedsLayout];
        [data release];
        data=nil;
        
        [aiView stopAnimating];
        [aiView removeFromSuperview];
        [aiView release];
        aiView = nil;
        return YES;
    }

    return NO;
}

- (void)connection:(NSURLConnection *)theConnection
    didReceiveData:(NSData *)incrementalData {
    if (data==nil) {
        data = [[NSMutableData alloc] initWithCapacity:2048];
    }
    [data appendData:incrementalData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [aiView stopAnimating];
    [aiView removeFromSuperview];
    [aiView release];
    aiView = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
    [connection release];
    connection=nil;
    
//    self.contentMode = UIViewContentModeScaleAspectFit;
//    self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self setImage:[UIImage imageWithData:data]];
    [self setNeedsLayout];
    //储存缓存
    [self addImageFile];
    
    [data release];
    data=nil;
    
    [aiView stopAnimating];
    [aiView removeFromSuperview];
    [aiView release];
    aiView = nil;
}

//- (UIImage*)image{
//    UIImageView* iv = [[self subviews] objectAtIndex:0];
//    return [iv image];
//}

- (void)dealloc {
    [aiView release];
    if (connection!=nil) {
        [connection cancel];
        [connection release];
    }
    [data release];
    [super dealloc];
}

@end