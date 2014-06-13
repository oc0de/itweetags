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
#import <Parse/Parse.h>

@interface EVMasterViewController () {
    NSMutableArray *_objects;

}

@end

@implementation EVMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createNewTagMessage:)];
    self.navigationItem.rightBarButtonItem = addButton;
    [self retrieveTagsNameFromParse];

}

-(void)retrieveTagsNameFromParse {
    PFQuery *tagClass = [PFQuery queryWithClassName:@"TagClass"];
    [tagClass whereKey:@"ownerName" equalTo:@"@butb0rn"];
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
    for (NSString *tag in _objects) {
        if ([newTag isEqualToString:tag] ) {
            return NO;
        }
    }
    return YES;
}

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
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[sender description ] atIndex:0];
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
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSString *object = _objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
