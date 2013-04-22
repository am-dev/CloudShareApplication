//
//  LargeImageViewController.h
//  CloudShareApplication
//
//  Created by Andrew Murphy on 04/04/2013.
//  Copyright (c) 2013 Andrew Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LargeImageViewController : UIViewController
{
    NSString *filepath;
    UIImageView *largeimage;
    UILabel *filenamelabel;
    NSString *filename;
    NSString *userid;
}


@property (retain, nonatomic) IBOutlet UIImageView *largeimage;
@property (retain, nonatomic) IBOutlet UILabel *filenamelabel;
@property (nonatomic, retain ) NSString *filepath;
@property (nonatomic, retain ) NSString *filename;
@property (nonatomic, retain ) NSString *userid;


-(IBAction)uploadselected:(id)sender;
@end
