//
//  Cell101Cell.m
//  CloudShareApplication
//
//  Created by Andrew on 26/03/2013.
//  Copyright (c) 2013 Andrew Murphy. All rights reserved.
//

#import "cellView.h"

@implementation cellView

@synthesize FileDownloadImage = _FileDownloadImage;
@synthesize FileDownloadLabel = _FileDownloadLabel;
@synthesize Filenamelabel = _Filenamelabel;
@synthesize uploaddatelabel = _uploaddatelabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
