//
//  EVStreamViewController.h
//  tweetags
//
//  Created by Ehsan Valizadeh on 6/13/14.
//  Copyright (c) 2014 ehsan_valizadeh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface EVStreamViewController : UITableViewController <UITextViewDelegate>
@property (strong, nonatomic) ACAccount *account;
@property (strong, nonatomic) NSMutableArray *updates;
@property (strong, nonatomic) NSString *hashtag;

@end
