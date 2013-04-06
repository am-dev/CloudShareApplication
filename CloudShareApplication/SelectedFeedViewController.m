//
//  SelectedFeedViewController.m
//  CloudShareApplication
//
//  Created by Andrew Murphy on 04/04/2013.
//  Copyright (c) 2013 Andrew Murphy. All rights reserved.
//

#import "SelectedFeedViewController.h"
#import "SBJson.h"
#import "SelectFeedCell.h"
#import "cellView.h"
#import "AFNetworking.h"

@interface SelectedFeedViewController ()

@end

@implementation SelectedFeedViewController
@synthesize fileid = _fileid;
@synthesize filecomments = _filecomments;


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
    
    NSLog(@"File ID : %@", self.fileid);
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0,0.0, self.view.bounds.size.width, 230)];
    self.webView.delegate = self;
    self.webView.hidden = NO;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    //NSString *fullURL = @"http://www.google.ie";
    //NSURL *url = [NSURL URLWithString:fullURL];
    //NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    //[webview loadRequest:requestObj];
    
    [self.webView addSubview:self.webView];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 230,
                                                                   self.view.bounds.size.width,
                                                                   self.view.bounds.size.height)
                                                  style:UITableViewStylePlain];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.autoresizingMask= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableview.hidden = NO;
    //[self.view addSubview:self.tableview];

    
    @try {
        //check if the text fields are empty if so error message triggered.
        if( [self.fileid isEqualToString:@""])
        {
            [self alertStatus:@"No content" :@"Please try again"];
        }
        else
        {
            self.filecomments = [[NSArray alloc] init];
            
            
            
            /*NSURL *url = [[NSURL alloc] initWithString:@"http://andysthesis.webhop.org/Php-services/getComments.php"];
            
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
            AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                                 {
                                                     //NSLog(@"%@", JSON);
                                                     self.filecomments = [JSON objectForKey:@"comments"];
                                                     //[self.activityindicator stopAnimating];
                                                     [self.tableview setHidden:NO];
                                                     [self.tableview reloadData];
                                                     
                                                 }
                                                                                                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                                                 {
                                                     NSLog(@"Request failed with error: %@, %@", error, error.userInfo);
                                                     [self alertStatus:@"No data returned" :@"Error"];
                                                 }];
            
            [operation start];
            */
            
            //Create string to post the username and password.
            NSString *post = [NSString stringWithFormat:@"fileID=%@", self.fileid];
            
            NSLog(@"PostData: %@",post);
            
            NSURL *url = [NSURL URLWithString:@"http://andysthesis.webhop.org/Php-services/getComments.php"];
            
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
                
                NSDictionary *jsonArray = (NSDictionary *) [jsonParser objectWithString:responseData error:nil];
                
                //NSDictionary *jsonData = (NSDictionary *) [jsonParser objectWithString:responseData error:nil];
                
                
                   NSLog(@"JSON DATA: %@",jsonArray); //create a dictionary for the json object.
                
                [self.tableview reloadData];
                
            } else {
                if (error) NSLog(@"Error: %@", error);
                
                [self alertStatus:@"Check Connection" :@"No Connection"];
            }
             
        }
             
    }
    @catch (NSException *e) {
        
        NSLog(@"Exception: %@", e);
        
        [self alertStatus:@"Connection Failed." :@"Con Failed!"];
    }
  
    
	// Do any additional setup after loading the view.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"cellView";
    
    NSDictionary *dict = [self.filecomments objectAtIndex:indexPath.row];
    
    NSLog(@"Dictionary : %@", dict);
    
    NSString *postid = [dict objectForKey:@"postid"];
    
    NSLog(@"Post ID : %@", postid);
    
    cellView *samplecell = ( cellView * )[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(samplecell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil];
        
        samplecell=[nib objectAtIndex:0];
    }
    
    if( self.fileid )
    {
        NSLog(@"Match Found");
        
        samplecell.uploaddatelabel.text = [dict objectForKey:@"commentdate"];
    
        samplecell.Filenamelabel.text = [dict objectForKey:@"username"];
        
    }
    
    return samplecell;

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ self.filecomments count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    //NSString *string = @"testing";
    //[self postComment:string :@"2"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
