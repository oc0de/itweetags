//
//  EVTagTableViewCell.h
//  tweetags
//
//  Created by Ehsan Valizadeh on 6/17/14.
//  Copyright (c) 2014 ehsan_valizadeh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVTagTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *tagImage;
@property (weak, nonatomic) IBOutlet UILabel *tagName;

@end
