//
//  Cell101Cell.h
//  CloudShareApplication
//
//  Created by Andrew on 26/03/2013.
//  Copyright (c) 2013 Andrew Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cellView : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *FileDownloadImage;
@property (weak, nonatomic) IBOutlet UILabel *FileDownloadLabel;
@property (weak, nonatomic) IBOutlet UILabel *Filenamelabel;
@property (weak, nonatomic) IBOutlet UILabel *uploaddatelabel;
@end
