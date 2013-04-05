//
//  TabController.m
//  CloudShareApplication
//
//  Created by Andrew Murphy on 04/04/2013.
//  Copyright (c) 2013 Andrew Murphy. All rights reserved.
//

#import "TabController.h"
#import "Tab1LocalViewController.h"
#import "Tab2FeedsViewControllerViewController.h"

@interface TabController ()

@end

@implementation TabController

@synthesize userid_loginid;

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
    
    //Tab1LocalViewController *tab1 = [[Tab1LocalViewController alloc] init];
    //Tab2FeedsViewControllerViewController *tab2 = [[Tab2FeedsViewControllerViewController alloc] init];
    
    //tab1.userid = self.userid_loginid;
    
    
    //NSLog(@"User login id: %@", self.userid_loginid);
    
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
