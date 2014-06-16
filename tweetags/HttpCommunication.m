//
//  HttpCommunication.m
//  TopTracksDemo
//
//  Created by Ehsan Valizadeh on 5/27/14.
//  Copyright (c) 2014 ehsan_valizadeh. All rights reserved.
//

#import "HttpCommunication.h"
#import "EVAppDelegate.h"

@interface HttpCommunication()
@property (nonatomic, copy) void (^successBlock)(NSData*);
@end

@implementation HttpCommunication

- (void)retrieveURL:(NSURL *)url successBlock:(void (^) (NSData*))successBlk {
    [(EVAppDelegate*)[[UIApplication sharedApplication] delegate] incrementNetworkActivity];
    self.successBlock = successBlk;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionConfiguration *conf = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:conf delegate:self delegateQueue:nil];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request];
    [task resume];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSData *data = [NSData dataWithContentsOfURL:location];
    dispatch_async(dispatch_get_main_queue(), ^ {
        [(EVAppDelegate*)[[UIApplication sharedApplication] delegate] decrementNetworkActivity];
        self.successBlock(data);
    });
}

@end
