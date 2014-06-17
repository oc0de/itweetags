//
//  EVMasterViewController.h
//  tweetags
//
//  Created by Ehsan Valizadeh on 6/9/14.
//  Copyright (c) 2014 ehsan_valizadeh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>

@interface EVMasterViewController : UITableViewController <UITableViewDelegate,
                                    UITableViewDataSource, UISearchDisplayDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) NSString *accountName;
@property (strong, nonatomic) ACAccount *account;


@end
