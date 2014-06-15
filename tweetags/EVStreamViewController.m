//
//  EVStreamViewController.m
//  tweetags
//
//  Created by Ehsan Valizadeh on 6/13/14.
//  Copyright (c) 2014 ehsan_valizadeh. All rights reserved.
//

#import "EVStreamViewController.h"


@interface EVStreamViewController ()

@end

@implementation EVStreamViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"updateTweet"];
    NSDictionary *tweet = self.updates[indexPath.row];
    NSDictionary *userInfo = tweet[@"user"];
    if ([self.account.accountType.identifier isEqualToString:ACAccountTypeIdentifierTwitter]) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@/\%@",userInfo[@"name"],tweet[@"created_at"]];
       // cell.textLabel.text = tweet[@"created_at"];
//        cell.textLabel.text = [tweet objectForKey:@"screen_name"];
//        cell.detailTextLabel.text   = [tweet valueForKeyPath:@"user.name"];
    }
    return cell;
}
- (IBAction)refreshButtonPressed:(UIRefreshControl *)sender {
    [self retrieveTwitterStream];
    [sender endRefreshing];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
