//
//  EVDetailViewController.h
//  tweetags
//
//  Created by Ehsan Valizadeh on 6/9/14.
//  Copyright (c) 2014 ehsan_valizadeh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVDetailViewController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) NSDictionary *detailTweet;
@property (weak, nonatomic) IBOutlet UIImageView *thumbNail;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UITextView *tweetDetail;
@property (weak, nonatomic) IBOutlet UILabel *createdAt;


@end
