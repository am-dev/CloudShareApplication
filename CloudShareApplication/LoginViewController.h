//
//  LoginViewController.h
//  CloudShareApplication
//
//  Created by Andrew on 20/03/2013.
//  Copyright (c) 2013 Andrew Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController {
    
    IBOutlet UITextField *UsernameField;
    IBOutlet UITextField *PasswordField;
    NSString *userid;
}

@property ( nonatomic, retain ) UITextField *UsernameField;
@property ( nonatomic, retain ) UITextField *PasswordField;
@property ( nonatomic, retain ) UIButton *loginbutton;
@property ( nonatomic, retain ) UIButton *createbutton;
@property ( nonatomic, retain ) NSString *userid;


- ( IBAction)Log_in:(id)sender;

- (IBAction)createnewaccount:(id)sender;

- (IBAction)BackgroundClick:(id)sender;

@end

