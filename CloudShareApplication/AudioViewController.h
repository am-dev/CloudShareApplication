//
//  ViewController.h
//  TestAudioFileHandler
//
//  Created by Andrew on 11/03/2013.
//  Copyright (c) 2013 Andrew Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *tableview;
    UIActivityIndicatorView *activityindicator;
    NSMutableArray *arrayoffiles;
    AVAudioPlayer *player;
    NSURL *urlselected;
    NSString *userloginID;
    NSString *title;
}

@property (nonatomic, retain) NSURL *urlselected;
@property (nonatomic, retain) UITableView *tableview;
@property (nonatomic, retain) UIActivityIndicatorView *activityindicator;
@property (nonatomic, retain) NSMutableArray *arrayoffiles;

@property (strong, nonatomic) IBOutlet UIImageView *Mp3ImageHolder;
@property (strong, nonatomic) IBOutlet UIButton *PlayButton;
@property (strong, nonatomic) IBOutlet UIButton *StopButton;
@property (strong, nonatomic) IBOutlet UIButton *FFButton;
@property (strong, nonatomic) IBOutlet UIButton *RWButton;
@property (strong, nonatomic) AVAudioPlayer *player;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *openlistofmp3;
@property (strong, nonatomic) IBOutlet UISlider *volumeslider;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (nonatomic, retain) NSString *userloginID;
@property (nonatomic, retain) NSString *Title;


- (IBAction)PlayPressed:(id)sender;
- (IBAction)StopPressed:(id)sender;
- (IBAction)FFPressed:(id)sender;
- (IBAction)RWPressed:(id)sender;
- (IBAction)openlistofmp3:(id)sender;
- (IBAction)volumechanged:(id)sender;
- (IBAction)sharebuttonselected:(id)sender;


@end
