//
//  ResultListTableViewCell.m
//  quickbite
//
//  Created by Saurabh Khawase on 11/07/14.
//  Copyright (c) 2014 sifar tech. All rights reserved.
//

#import "ResultListTableViewCell.h"

@implementation ResultListTableViewCell

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

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];

    self.opaque = YES;
    [self.textLabel setFont:[UIFont systemFontOfSize:12]];
    self.textLabel.numberOfLines = 0;

}

@end
