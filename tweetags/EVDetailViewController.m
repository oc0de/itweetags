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
- (IBAction)toggleMap:(id)sender {
    [self.mapView setHidden:![self.mapView isHidden]];
}


- (void)configureView
{
    if (self.detailItem) {
        NSDictionary *userInfo = self.detailItem[@"user"];
        self.userName.text = userInfo[@"name"];
        
        if ([userInfo[@"location"] isEqualToString:@""]) {
            self.location.text = @"No Location";
        } else {
            self.location.text = userInfo[@"location"];
        }
        
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
        NSDate *date = [dateFormat dateFromString:userInfo[@"created_at"]];
        [dateFormat setDateFormat:@"eee MMM dd yyyy"];
        NSString *dateStr = [dateFormat stringFromDate:date];
        self.createdAt.text = dateStr;
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
