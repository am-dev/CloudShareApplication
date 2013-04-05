//
//  LiveFeedCell.m
//  CloudShareApplication
//
//  Created by Andrew Murphy on 02/04/2013.
//  Copyright (c) 2013 Andrew Murphy. All rights reserved.
//

#import "LiveFeedCell.h"

@implementation LiveFeedCell
@synthesize commenttopost;
@synthesize commentfield;

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

-(IBAction)backgroundclick:(id)sender
{
    [self.commentfield resignFirstResponder];
}

-(IBAction)postcomment:(id)sender
{
    NSLog(@"posted");
    //commenttopost = commentfield.text;
}

@end
