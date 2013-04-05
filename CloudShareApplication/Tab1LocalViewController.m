//
//  Tab1LocalViewController.m
//  CloudShareApplication
//
//  Created by Andrew on 20/03/2013.
//  Copyright (c) 2013 Andrew Murphy. All rights reserved.
//

#import "Tab1LocalViewController.h"
#import "PhotoViewController.h"
#import "TextEditViewController.h"
#import "AudioViewController.h"

@interface Tab1LocalViewController ()

@end

@implementation Tab1LocalViewController

@synthesize userid = _userid;

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
	// Do any additional setup after loading the view.
    NSLog(@"User id passed to tab1 : %@", self.userid);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)mp3playerselected:(id)sender
{
    NSLog(@"id : %@", self.userid);
    
    [self performSegueWithIdentifier:@"sendingid" sender:self];
    
}

-(IBAction)imagepickerselected:(id)sender
{
    
}

-(IBAction)texteditorselected:(id)sender
{
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"sendingid"]) {
        AudioViewController *controller = segue.destinationViewController;
        
        controller.userloginID = self.userid;
    }
}



@end
