//
//  LiveFeedCell.h
//  CloudShareApplication
//
//  Created by Andrew Murphy on 02/04/2013.
//  Copyright (c) 2013 Andrew Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveFeedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *livefeedImage;
@property (weak, nonatomic) IBOutlet UILabel *livefeedfilename;
@property (weak, nonatomic) IBOutlet UILabel *livefeedusername;
@property (weak, nonatomic) IBOutlet UITextView *commentfield;
@property (weak, nonatomic) IBOutlet UIButton *postcomment;
@property (weak, nonatomic) NSString *commenttopost;

-(IBAction)backgroundclick:(id)sender;
-(IBAction)postcomment:(id)sender;
@end
