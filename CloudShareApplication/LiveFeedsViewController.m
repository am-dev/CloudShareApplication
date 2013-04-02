//
//  LiveFeedsViewController.m
//  CloudShareApplication
//
//  Created by Andrew on 27/03/2013.
//  Copyright (c) 2013 Andrew Murphy. All rights reserved.
//

#import "LiveFeedsViewController.h"
#import "cellView.h"
#import "AFNetworking.h"

@interface LiveFeedsViewController ()

@end

@implementation LiveFeedsViewController

@synthesize livefeeds = _liveFeeds;
@synthesize activityindicator = _activityIndicator;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0,
                                                                   self.view.bounds.size.width,
                                                                   self.view.bounds.size.height)
                                                  style:UITableViewStyleGrouped];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.autoresizingMask= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableview.hidden = YES;
    [self.view addSubview:self.tableview];
    
    self.activityindicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityindicator.hidesWhenStopped = YES;
    self.activityindicator.center = self.view.center;
    [self.view addSubview:self.activityindicator];
    [self.activityindicator startAnimating];
    
    self.livefeeds = [[NSArray alloc] init];
    
    NSURL *url = [[NSURL alloc] initWithString:@"http://andysthesis.webhop.org/Php-services/json.php"];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
    {
        NSLog(@"%@", JSON);
        self.livefeeds = [JSON objectForKey:@"members"];
        [self.activityindicator stopAnimating];
        [self.tableview setHidden:NO];
        [self.tableview reloadData];
                                             
    }
    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
    {
        NSLog(@"Request failed with error: %@, %@", error, error.userInfo);
        [self alertStatus:@"No data returned" :@"Error"];
    }];
    
    [operation start];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cellView";
    NSDictionary *feeds = [self.livefeeds objectAtIndex:indexPath.row];
    
    cellView *samplecell = ( cellView * )[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(samplecell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil];
        samplecell=[nib objectAtIndex:0];
    }
    samplecell.FileDownloadLabel.text = [feeds objectForKey:@"username"];
    samplecell.Filenamelabel.text = [feeds objectForKey:@"file_name"];
    samplecell.uploaddatelabel.text = [feeds objectForKey:@"uploadDate"];
    NSURL *url = [[NSURL alloc] initWithString:[feeds objectForKey:@"user_profileimage"]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    samplecell.FileDownloadImage.image = [[UIImage alloc] initWithData:data];
    
    return samplecell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ self.livefeeds count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}

- (IBAction)Reloadtable:(id)sender
{    
    [self.tableview reloadData];
}
@end
