//
//  EVDetailViewController.m
//  tweetags
//
//  Created by Ehsan Valizadeh on 6/9/14.
//  Copyright (c) 2014 ehsan_valizadeh. All rights reserved.
//

#import "EVDetailViewController.h"
#import "UIImageView+Network.h"
#import <QuartzCore/QuartzCore.h>

@interface EVDetailViewController ()
- (void)configureView;
@end

@implementation EVDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    if (self.detailItem) {
        NSDictionary *userInfo = self.detailItem[@"user"];
        self.userName.text = userInfo[@"name"];
        self.screenName.text    = [NSString stringWithFormat:@"@%@",userInfo[@"screen_name"]];
        self.tweetDetail.text   = self.detailItem[@"text"];
        NSString *imageUrl      = [NSString stringWithFormat:@"%@",userInfo[@"profile_image_url"]];
        if (imageUrl != nil ) {
            self.thumbNail.layer.cornerRadius = 4.5;
            self.thumbNail.clipsToBounds = YES;
            [self.thumbNail loadImageFromURL:[NSURL URLWithString:imageUrl]
                                       placeholderImage:[UIImage imageNamed:@"noProfileImage"] cachingKey:imageUrl];
        } else {
            self.thumbNail.image = [UIImage imageNamed:@"noProfileImage"];
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
