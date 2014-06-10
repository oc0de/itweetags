//
//  AccountViewController.m
//  SocialDemo
//
//  Created by Ehsan Valizadeh on 6/5/14.
//  Copyright (c) 2014 ehsan_valizadeh. All rights reserved.
//

#import "EVAccountsViewController.h"



@interface EVAccountsViewController ()

@end

@implementation EVAccountsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.accounts = [[NSMutableArray alloc] init];
    [self retrieveAccounts:ACAccountTypeIdentifierTwitter options:nil];
}

- (void)retrieveAccounts:(NSString *)identifier options:(NSDictionary *)options
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType  *accountType = [accountStore accountTypeWithAccountTypeIdentifier:identifier];
    [accountStore requestAccessToAccountsWithType:accountType options:options completion:^(BOOL granted, NSError *error) {
        if (granted) {
            [self.accounts addObjectsFromArray:[accountStore accountsWithAccountType:accountType]];
            dispatch_async(dispatch_get_main_queue(), ^{
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

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.accounts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"accountCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    ACAccount *account = self.accounts[indexPath.row];
    cell.textLabel.text = account.accountDescription;
    return cell;
}

#pragma mark - Navigation

//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    NSIndexPath *selectedIndex = self.tableView.indexPathForSelectedRow;
//    ACAccount *account = [self.accounts objectAtIndex:selectedIndex.row];
//    StreamViewController *dest = [segue destinationViewController];
//    dest.title = [self.tableView cellForRowAtIndexPath:selectedIndex].textLabel.text;
//    dest.account = account;
//}


@end
