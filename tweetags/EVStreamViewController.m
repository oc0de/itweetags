//
//  EVStreamViewController.m
//  tweetags
//
//  Created by Ehsan Valizadeh on 6/13/14.
//  Copyright (c) 2014 ehsan_valizadeh. All rights reserved.
//

#import "EVStreamViewController.h"
#import "EVTableViewCell.h"
#import "UIImageView+Network.h"
#import <QuartzCore/QuartzCore.h>


@interface EVStreamViewController ()

@property (strong,nonatomic) EVTableViewCell *customCell;

@end

@implementation EVStreamViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.updates = [[NSMutableArray alloc] init];
    if ([self.account.accountType.identifier isEqualToString:ACAccountTypeIdentifierTwitter]) {
        [self retrieveTwitterStream];
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

-(void)retrieveTwitterStream {
    NSString *hashtag = [NSString stringWithFormat:@"#%@",self.hashtag];
    NSString *encodedQuery = [hashtag stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url  = [NSURL URLWithString:  @"https://api.twitter.com/1.1/search/tweets.json"];
    NSDictionary *params = @{@"q" : encodedQuery, @"count" : @"50"};
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:params];
    [request setAccount:self.account];
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (urlResponse.statusCode == 200) {
            NSError *parsingError = nil;
            NSDictionary *jsonResults = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&parsingError];
            self.updates = jsonResults[@"statuses"];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.updates.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
    NSDictionary *tweet = self.updates[indexPath.row];
    NSDictionary *userInfo = tweet[@"user"];
    if ([self.account.accountType.identifier isEqualToString:ACAccountTypeIdentifierTwitter]) {
        cell.userName.text      = [NSString stringWithFormat:@"%@",userInfo[@"name"]];
        cell.screenName.text    = [NSString stringWithFormat:@"@%@",userInfo[@"screen_name"]];
        cell.tweetText.text     = [NSString stringWithFormat:@"%@",tweet[@"text"]];
        NSString *imageUrl      = [NSString stringWithFormat:@"%@",userInfo[@"profile_image_url"]];
        NSString *imageHttpsUrl = [NSString stringWithFormat:@"%@",userInfo[@"profile_image_url_https"]];
        if (imageUrl != nil ) {
            cell.thumbnail.layer.cornerRadius = 4.5;
            cell.thumbnail.clipsToBounds = YES;
            [cell.thumbnail loadImageFromURL:[NSURL URLWithString:imageUrl]
                            placeholderImage:[UIImage imageNamed:@"noProfileImage"] cachingKey:imageUrl];
        } else if (imageHttpsUrl != nil) {
            NSLog(@"imageHttpsUrl");
            [cell.thumbnail loadImageFromURL:[NSURL URLWithString:imageHttpsUrl]
                            placeholderImage:[UIImage imageNamed:@"noProfileImage"] cachingKey:imageHttpsUrl];
        } else {
            cell.thumbnail.image = [UIImage imageNamed:@"noProfileImage"];
        }
        
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.customCell) {
        self.customCell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
    }
    
    NSDictionary *tweet = self.updates[indexPath.row];
    NSDictionary *userInfo = tweet[@"user"];
    if ([self.account.accountType.identifier isEqualToString:ACAccountTypeIdentifierTwitter]) {
        self.customCell.userName.text      = userInfo[@"name"];
        self.customCell.screenName.text    = [NSString stringWithFormat:@"@%@",userInfo[@"screen_name"]];
        self.customCell.tweetText.text     = [NSString stringWithFormat:@"%@",tweet[@"text"]];
        NSString *imageUrl      = [NSString stringWithFormat:@"%@",userInfo[@"profile_image_url"]];
        NSString *imageHttpsUrl = [NSString stringWithFormat:@"%@",userInfo[@"profile_image_url_https"]];
        if (imageUrl != nil ) {
            self.customCell.thumbnail.layer.cornerRadius = 4.5;
            self.customCell.thumbnail.clipsToBounds = YES;
            [self.customCell.thumbnail loadImageFromURL:[NSURL URLWithString:imageUrl]
                                       placeholderImage:[UIImage imageNamed:@"noProfileImage"] cachingKey:imageUrl];
        } else if (imageHttpsUrl != nil) {
            NSLog(@"imageHttpsUrl");
            [self.customCell.thumbnail loadImageFromURL:[NSURL URLWithString:imageHttpsUrl]
                                       placeholderImage:[UIImage imageNamed:@"noProfileImage"] cachingKey:imageHttpsUrl];
        } else {
            self.customCell.thumbnail.image = [UIImage imageNamed:@"noProfileImage"];
        }
    }
    
    [self.customCell layoutIfNeeded];
    
    CGFloat height = [self.customCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    return height+1;
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}


- (IBAction)refreshButtonPressed:(UIRefreshControl *)sender {
    [self retrieveTwitterStream];
    [sender endRefreshing];
}


 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     if ([[segue identifier] isEqualToString:@"showTweet"]) {
         NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
         NSDictionary *tweet = self.updates[indexPath.row];
        [[segue destinationViewController] setDetailItem:tweet];
     }
 }


@end
