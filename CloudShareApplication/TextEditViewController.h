//
//  TextEditViewController.h
//  CloudShareApplication
//
//  Created by Andrew on 01/04/2013.
//  Copyright (c) 2013 Andrew Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextEditViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *tableview;
    NSMutableArray *arrayoffiles;
    NSURL *urlselected;
    NSString *selected;
    NSString *filetitle;
    NSString *userloginID;
}

@property (weak, nonatomic) IBOutlet UITextField *texttitle;
@property (weak, nonatomic) IBOutlet UITextView *textcontent;
@property (nonatomic, retain) NSMutableArray *arrayoffiles;
@property (nonatomic, retain) UITableView *tableview;
@property (nonatomic, retain) NSURL *urlselected;
@property (nonatomic, retain) NSString *selected;
@property (nonatomic, retain) NSString *filetitle;
@property (nonatomic, retain) NSString *userloginID;

- (IBAction)savetextButton:(id)sender;

- (IBAction)BackgroundClick:(id)sender;

- (IBAction)ShareButtonSelected:(id)sender;

- (IBAction)loadlocalfiles:(id)sender;

@end
