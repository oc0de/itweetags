//
//  HttpCommunication.h
//  TopTracksDemo
//
//  Created by Ehsan Valizadeh on 5/27/14.
//  Copyright (c) 2014 ehsan_valizadeh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpCommunication : NSObject <NSURLSessionDataDelegate>
- (void)retrieveURL:(NSURL *)url successBlock:(void (^) (NSData*))successBlk;

@end
