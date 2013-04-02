//
//  LoginViewController.m
//  CloudShareApplication
//  
//  Created by Andrew on 20/03/2013.
//  Copyright (c) 2013 Andrew Murphy. All rights reserved.
//
//  The login view controller controls the login of users.
//  Posting username and data, returning json object.
//

#import "LoginViewController.h"
#import "Tab1LocalViewController.h"
#import "SBJson.h"
#import "AudioViewController.h"
#import "CreateNewUserViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize UsernameField;
@synthesize PasswordField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) alertStatus:(NSString *)msg :(NSString *)title
{
    //Alert Box method called when user enters either the wrong info
    //or no connection can be made to the db.
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    
    [alertView show];
}
/*
 * User enter two values,
 * Username and Password: to correspond with the details entered when creating
 * your user account.
 */
- (IBAction)Log_in:(id)sender {
    
    @try {
        //check if the text fields are empty if so error message triggered.
        if( [UsernameField.text isEqualToString:@""] || [PasswordField.text isEqualToString:@""])
        {
            [self alertStatus:@"Username of password is empty" :@"Please try again"];
        }
        else
        {
        //Create string to post the username and password.
        NSString *post = [NSString stringWithFormat:@"username=%@&password=%@",UsernameField.text, PasswordField.text];
        NSLog(@"PostData: %@",post);
        
        NSURL *url = [NSURL URLWithString:@"http://andysthesis.webhop.org/Php-services/UserLogin.php"];
        //Convert the post string to type data, create string for length of post.
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postlength = [NSString stringWithFormat:@"%d", [postData length]];
        //Create new instance of a Url Request.
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        //set the values to request.
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postlength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        NSError *error = [[NSError alloc] init];
        NSHTTPURLResponse *response = nil;
        NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
        NSLog(@"Response code: %d", [response statusCode]);
        //verify the response code if and only if response code between 200 and 300 continue
        //for example if a 404 response( page not found ) throw error.
        if ([response statusCode] >=200 && [response statusCode] <300)
        {
            NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
            NSLog(@"Response ==> %@", responseData);
            
            SBJsonParser *jsonParser = [SBJsonParser new]; //create new parser
            NSDictionary *jsonData = (NSDictionary *) [jsonParser objectWithString:responseData error:nil];
            NSLog(@"JSON DATA: %@",jsonData); //create a dictionary for the json object.
            NSInteger success = [(NSNumber *) [jsonData objectForKey:@"success"] integerValue];
            //response data should contain a 1 or 0 with the key "Success"
            //1 meaning a successful match has been made. 0 preventing login
            
            UITabBarController *tabctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"TabController"];
            
            
            if(success == 1)
            {
                NSString *loginID = (NSString *)[jsonData objectForKey:@"userid"];
                NSLog(@"User ID: %@", loginID);
                [self presentViewController:tabctrl animated:YES completion:NULL];
                
            } else {
                
                NSString *error_msg = (NSString *) [jsonData objectForKey:@"error_message"];
                [self alertStatus:error_msg :@"Login Failed!"];
            }
            
        } else {
            if (error) NSLog(@"Error: %@", error);
            [self alertStatus:@"Check Connection" :@"No Connection"];
        }
    }
    }
    @catch (NSException *e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Login Failed." :@"Login Failed!"];
    }
}

- (IBAction)createnewaccount:(id)sender
{
    
}

- (IBAction)BackgroundClick:(id)sender {
    
    //controls the closing of the keyboard in order to access the whole screen.
    
    [UsernameField resignFirstResponder];
    [PasswordField resignFirstResponder];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
