//
//  SelectFeedCell.h
//  CloudShareApplication
//
//  Created by Andrew Murphy on 04/04/2013.
//  Copyright (c) 2013 Andrew Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectFeedCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *Userimage;

@property (weak, nonatomic) IBOutlet UILabel *Username;

@property (weak, nonatomic) IBOutlet UITextView *UserComment;

@end
