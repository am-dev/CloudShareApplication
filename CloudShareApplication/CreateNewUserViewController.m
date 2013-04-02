//
//  CreateNewUserViewController.m
//  CloudShareApplication
//
//  Created by Andrew on 27/03/2013.
//  Copyright (c) 2013 Andrew Murphy. All rights reserved.
//

#import "CreateNewUserViewController.h"
#import "SBJson.h"
#import <QuartzCore/QuartzCore.h>


@interface CreateNewUserViewController ()

@end

@implementation CreateNewUserViewController
@synthesize NewUsername;
@synthesize NewFirstName;
@synthesize NewLastName;
@synthesize NewEmail;
@synthesize NewPassword;
@synthesize scrollercontrol;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    scrollercontrol.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    scrollercontrol.maximumZoomScale = 4.0;
    scrollercontrol.minimumZoomScale = 0.75;
    scrollercontrol.clipsToBounds = YES;
    scrollercontrol.delegate = self;
    //[scrollercontrol addSubview:];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)BackgroundClick:(id)sender
{
    [NewUsername resignFirstResponder];
    [NewFirstName resignFirstResponder];
    [NewLastName resignFirstResponder];
    [NewEmail resignFirstResponder];
    [NewPassword resignFirstResponder];
}

- (IBAction)createnewuserButtonSelected:(id)sender
{
    
    @try {
        
        if ( [NewUsername.text isEqualToString:@""]
            || [NewFirstName.text isEqualToString:@""]
            || [NewLastName.text isEqualToString:@""]
            || [NewEmail.text isEqualToString:@""]
            || [NewPassword.text isEqualToString:@""])
        {
            [self alertStatus:@"One or more of the fields are null" :@"Oops!!"];
        }
        else
        {
            
            NSString *post = [NSString stringWithFormat:@"username=%@&firstname=%@&lastname=%@&email=%@&password=%@",NewUsername.text, NewFirstName.text, NewLastName.text, NewEmail.text, NewPassword.text];
            NSLog(@"PostData: %@",post);
            
            NSURL *url = [NSURL URLWithString:@"http://andysthesis.webhop.org/Php-services/newUser.php"];
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
                    [self alertStatus:@"Welcome!" :@"Account Created"];
                    [self presentViewController:tabctrl animated:YES completion:NULL];
                }
                else if ( success == 2) {
                    
                    [self alertStatus:@"Username of email already in user" :@"No can do!"];
                }
                
            } else {
                if (error) NSLog(@"Error: %@", error);
                [self alertStatus:@"Unable to establish a connection" :@"No Connection"];
            }
        }
    }
    @catch (NSException *e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Login Failed." :@"Login Failed!"];
    }
}

@end
