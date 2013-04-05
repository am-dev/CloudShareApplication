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
#import "SBJson.h"
#import "LiveFeedCell.h"
#import "SelectedFeedViewController.h"

@interface LiveFeedsViewController ()

@end

@implementation LiveFeedsViewController

@synthesize livefeeds = _liveFeeds;
@synthesize activityindicator = _activityIndicator;
@synthesize userid = _userid;
@synthesize fileid = _fileID;

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
    
    //NSLog(@"User id : %@", self.userid);
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0.0,0.0,
                                                                   self.view.bounds.size.width,
                                                                   self.view.bounds.size.height)
                                                  style:UITableViewStylePlain];
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
    static NSString *identifier = @"LiveFeedCell";
    
    NSDictionary *feeds = [self.livefeeds objectAtIndex:indexPath.row];
    
    LiveFeedCell *samplecell = ( LiveFeedCell * )[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(samplecell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil];
        
        samplecell=[nib objectAtIndex:0];
    }
    
    samplecell.livefeedusername.text = [feeds objectForKey:@"file_type"];
    
    samplecell.livefeedfilename.text = [feeds objectForKey:@"username"];
    
    //samplecell.uploaddatelabel.text = [feeds objectForKey:@"uploadDate"];
    NSURL *url = [[NSURL alloc] initWithString:[feeds objectForKey:@"fileURL"]];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    samplecell.livefeedImage.image = [[UIImage alloc] initWithData:data];
    
    samplecell.commentfield.text = @"test";
    
    return samplecell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ self.livefeeds count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *feeds = [self.livefeeds objectAtIndex:indexPath.row];
    
    NSString *fileID = [feeds objectForKey:@"postid"];
    
    NSLog(@"file ID : %@", fileID);
    
    self.fileid = fileID;
    
    [self performSegueWithIdentifier:@"passingfileID" sender:self];
    
    //NSString *string = @"testing";
    //[self postComment:string :@"2"];
}

- (IBAction)Reloadtable:(id)sender
{    
    [self.tableview reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"passingfileID"]) {
        
        SelectedFeedViewController *controller = segue.destinationViewController;
        
        controller.fileid = self.fileid;
    }
}

-(void)postComment:(NSString *)comment :(NSString *)fileID
{
    
    
    @try {
        //check if the text fields are empty if so error message triggered.
        if( [comment isEqualToString:@""])
        {
            [self alertStatus:@"No content" :@"Please try again"];
        }
        else
        {
            //Create string to post the username and password.
            NSString *post = [NSString stringWithFormat:@"comment=%@&fileID=%@",comment, fileID];
            
            NSLog(@"PostData: %@",post);
            
            NSURL *url = [NSURL URLWithString:@"http://andysthesis.webhop.org/Php-services/CommentOnPost.php"];
            
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
                
                //UITabBarController *tabctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"TabController"];
                
                
                if(success == 1)
                {
                    
                    NSLog(@"Comment Uploaded");
                    
                    
                } else {
                    
                    NSString *error_msg = (NSString *) [jsonData objectForKey:@"error_message"];
                    
                    [self alertStatus:error_msg :@"Login Failed!"];
                }
                
            } else {
                if (error)
                
                    NSLog(@"Error: %@", error);
                
                    [self alertStatus:@"Check Connection" :@"No Connection"];
            }
        }
    }
    @catch (NSException *e) {
        
        NSLog(@"Exception: %@", e);
        
        [self alertStatus:@"Login Failed." :@"Login Failed!"];
    }

    
}

@end
