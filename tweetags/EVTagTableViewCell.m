//
//  EVTagTableViewCell.m
//  tweetags
//
//  Created by Ehsan Valizadeh on 6/17/14.
//  Copyright (c) 2014 ehsan_valizadeh. All rights reserved.
//

#import "EVTagTableViewCell.h"

@implementation EVTagTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
