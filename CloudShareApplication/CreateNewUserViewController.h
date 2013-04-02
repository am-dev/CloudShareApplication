//
//  CreateNewUserViewController.h
//  CloudShareApplication
//
//  Created by Andrew on 27/03/2013.
//  Copyright (c) 2013 Andrew Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateNewUserViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *NewUsername;
@property (weak, nonatomic) IBOutlet UITextField *NewFirstName;
@property (weak, nonatomic) IBOutlet UITextField *NewLastName;
@property (weak, nonatomic) IBOutlet UITextField *NewEmail;
@property (weak, nonatomic) IBOutlet UITextField *NewPassword;
@property (retain, nonatomic) UIScrollView *scrollercontrol;

- (IBAction)createnewuserButtonSelected:(id)sender;

- (IBAction)BackgroundClick:(id)sender;

@end
