//
//  EVMasterViewController.m
//  tweetags
//
//  Created by Ehsan Valizadeh on 6/9/14.
//  Copyright (c) 2014 ehsan_valizadeh. All rights reserved.
//

#import "EVMasterViewController.h"
#import "EVDetailViewController.h"
#import "EVAccountsViewController.h"
#import "EVStreamViewController.h"
#import "EVTagTableViewCell.h"
#import <Parse/Parse.h>


@interface EVMasterViewController () {
    //NSMutableArray *_objects;
}
@property (strong, nonatomic) NSArray *searchResults;
@property (strong, nonatomic) NSMutableArray *objects;
@property (strong,nonatomic) EVTagTableViewCell *customCell;


@end

@implementation EVMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchResults = [[NSArray alloc] init];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createNewTagMessage:)];
    self.navigationItem.rightBarButtonItem = addButton;
    [self retrieveTagsNameFromParse];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createNewTagMessage:(id)sender {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"New Tag" message:@"Enter a name for this tag."
                                                     delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [message show];
}



- (IBAction)repetitiveTagNameMessage {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You Have this tag already."
                                                     delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (NSString*)returnTextFiledAlertMessage:(UIAlertView *)alertView {
    
    return [[alertView textFieldAtIndex:0] text];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
    } else {
        NSString *sender = [self returnTextFiledAlertMessage:(UIAlertView *)alertView];
        if ([self checkUniqueTagName:[sender description]]) {
            [self insertNewObject:[sender description]];
            [self saveTagNameToParse:sender];
        }else {
            [self repetitiveTagNameMessage];
        }
    }
}


-(BOOL)checkUniqueTagName:(NSString *)newTag {
    for (NSString *tag in self.objects) {
        if ([newTag isEqualToString:tag] ) {
            return NO;
        }
    }
    return YES;
}

#pragma Retrieve data from parse

-(void)retrieveTagsNameFromParse {
    NSString *ownerName = self.accountName;
    PFQuery *tagClass = [PFQuery queryWithClassName:@"TagClass"];
    [tagClass whereKey:@"ownerName" equalTo:ownerName];
    [tagClass findObjectsInBackgroundWithBlock:^(NSArray *tags, NSError *error) {
        if (!error) {
            for (PFObject *tag in tags) {
                [self insertNewObject:tag[@"tagName"]];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

#pragma save data into parse

-(void)saveTagNameToParse:(NSString *)sender {
    PFObject *tag = [PFObject objectWithClassName:@"TagClass"];
    NSString *tagName = [NSString stringWithFormat:@"%@",[sender description]];
    tag[@"ownerName"] = self.accountName;
    tag[@"tagName"] = tagName;
    [tag saveInBackground];
}


- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView {
    
    if ([[self returnTextFiledAlertMessage:(UIAlertView*)alertView] length] >= 1) {
        return YES;
    } else {
        return NO;
    }
}


- (void)insertNewObject:(NSString *)sender
{
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    [self.objects insertObject:[sender description ] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView ) {
        return [self.searchResults count];
    }
    else {
        return [self.objects count];
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"TagCell";  //UITableViewCell
    EVTagTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[EVTagTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (tableView == self.searchDisplayController.searchResultsTableView) {
//        cell.textLabel.text = [self.searchResults objectAtIndex:indexPath.row];
        cell.tagName.text = [self.searchResults objectAtIndex:indexPath.row];
        
    } else {
//        cell.textLabel.text = [self.objects objectAtIndex:indexPath.row];
        cell.tagName.text = [self.objects objectAtIndex:indexPath.row];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *tagName = [self.objects objectAtIndex:indexPath.row];
        NSString *ownerName = self.accountName;
        PFQuery *query = [PFQuery queryWithClassName:@"TagClass"];
        [query whereKey:@"ownerName" equalTo:ownerName];
        [query findObjectsInBackgroundWithBlock:^(NSArray *object,NSError *err)
         {
             if (!err && object.count != 0){
                 for (PFObject *tag in object) {
                     if ([tag[@"tagName"] isEqualToString:tagName]) {
                         [tag deleteEventually];
                     }
                 }
             }
             else{
                 NSLog(@"Error");
             }
         }];
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
       
    }
}


#pragma Search Methods

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", searchText];
    self.searchResults = [self.objects filteredArrayUsingPredicate:predicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

#pragma prepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"showTweets"]) {
//        NSIndexPath *selectedTag = [self.tableView indexPathForSelectedRow];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *tweet = self.objects[indexPath.row];
        ACAccount *account = [self account];
        EVStreamViewController *showTweets = segue.destinationViewController;
       
        if (self.searchDisplayController.active) {
            NSIndexPath *selectedTagFromSearchResult = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            NSString *tweet = self.searchResults[selectedTagFromSearchResult.row];
            showTweets.title = tweet;
            showTweets.hashtag = tweet;
            showTweets.account = account;
        } else {
            showTweets.title = tweet;
            showTweets.hashtag = tweet;
            showTweets.account = account;
        }
    }
}

@end
