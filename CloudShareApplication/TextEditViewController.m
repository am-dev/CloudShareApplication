//
//  TextEditViewController.m
//  CloudShareApplication
//
//  Created by Andrew on 01/04/2013.
//  Copyright (c) 2013 Andrew Murphy. All rights reserved.
//

#import "TextEditViewController.h"
#import "SBJson.h"

@interface TextEditViewController ()

@end

@implementation TextEditViewController
@synthesize textcontent = _textcontent;
@synthesize texttitle = _texttitle;
@synthesize urlselected = _urlselected;
@synthesize tableview = _tableview;
@synthesize arrayoffiles = _arrayoffiles;
@synthesize selected = _selected;
@synthesize filetitle = _filetitle;

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

+ (void) alertStatus:(NSString *)msg :(NSString *)title
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ( self.arrayoffiles && self.arrayoffiles.count )
    {
     
        return self.arrayoffiles.count;
    }
    else
    {
        
        return 0;
        
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellid = @"Cellid";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if ( cell == nil)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
    
    //NSDictionary *files = [self.arrayoffiles objectAtIndex:indexPath.row];
    cell.textLabel.text = [self.arrayoffiles objectAtIndex:indexPath.row];
    
    
    
    self.selected = [self.arrayoffiles objectAtIndex:indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    NSString *title = [self.arrayoffiles objectAtIndex:indexPath.row];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString *documentsDir = [paths objectAtIndex:0];
    
    NSString *filepath = [NSString stringWithFormat:@"%@/%@", documentsDir, title];
    
    self.selected = filepath;
    
    self.filetitle = title;
    
    self.tableview.hidden = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)BackgroundClick:(id)sender
{
    [_textcontent resignFirstResponder];
    [_texttitle resignFirstResponder];
    
}
- (IBAction)savetextButton:(id)sender {
    
    if ( [self.texttitle.text isEqualToString:@""])
    {
        [self alertStatus:@"Please enter a document title" :@"Error"];
    }
    else
    {
        NSString *titleString = self.texttitle.text;
    
        titleString = [titleString stringByAppendingPathExtension:@"txt"];
    
        NSString *ContentString = self.textcontent.text;
    
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
        
        NSString *documentsDir = [paths objectAtIndex:0];
    
        NSString *filepath = [NSString stringWithFormat:@"%@/%@", documentsDir, titleString];
        
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:filepath])
    {

        NSError *err;
        [ContentString writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:&err];
        
        if( [[NSFileManager defaultManager] isWritableFileAtPath:filepath])
        {
            NSLog(@"File Written");
            [self alertStatus:filepath: @"Created"];
        }
        else
        {
            NSLog(@"Error");
        }

    }
    else
    {
        [self alertStatus:@"The filename already exits!" :@"File name error"];
    }
    }
    
}

- (IBAction)ShareButtonSelected:(id)sender
{
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:self.selected];
    
    NSLog(@"data : %@", self.selected);
    
    NSString *filename = self.filetitle;
    
    filename = [filename stringByAppendingFormat:@"%@",filename];
    
    NSString *userid = @"2";
    
    [[self class] uploadfile:data :filename :userid];
    
}

- (IBAction)ShareEncButtonSelected:(id)sender
{
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:self.selected];
    
    NSLog(@"data : %@", self.selected);
    
    NSString *filename = self.filetitle;
    
    filename = [filename stringByAppendingFormat:@"%@",filename];
    
    NSString *userid = @"2";
    
    [[self class] uploadfile:data :filename :userid];
    
}

- (IBAction)loadlocalfiles:(id)sender
{
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width,self.view.bounds.size.height) style:UITableViewStylePlain];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableview.hidden = YES;
    [self.view addSubview:self.tableview];
    
    // initializing the data source
    self.arrayoffiles = [[NSMutableArray alloc] init];
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSDirectoryEnumerator *directoryEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:documentsDirectory];
    
    NSLog(@"Doc Dir: %@", documentsDirectory);
    
    for (NSString *path in directoryEnumerator)
    {
        //check for all music file formats you need to play
        if ([[path pathExtension] isEqualToString:@"txt"] || [[path pathExtension] isEqualToString:@"aiff"] )
        {
            [self.arrayoffiles addObject:path];
        }
    }
    
    if(self.arrayoffiles.count != 0)
    {
        
        //[self.activityindicator stopAnimating];
        self.tableview.hidden = NO;
        
    }
    
}

+(NSString *)uploadfile:(NSData *)filedata :(NSString *)filename :(NSString *)userid
{
    //NSInteger randomNumber = arc4random() % 16;
    //NSString *randnumstring = [NSString stringWithFormat:@"%d", randomNumber];
    
    
    
    @try{
        
        NSString *post1 = [NSString stringWithFormat:@"userid=%@&filename=%@", userid, filename];
        NSURL *serviceURL = [NSURL URLWithString:@"http://andysthesis.webhop.org/Php-services/UploadTXT.php"];
        NSData *postData = [post1 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postlength = [NSString stringWithFormat:@"%d", post1.length];
        
        NSMutableURLRequest *_request = [[NSMutableURLRequest alloc] init ];
        
        [_request setURL:serviceURL];
        [_request setHTTPMethod:@"POST"];
        [_request setValue:postlength forHTTPHeaderField:@"Content-Length"];
        [_request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [_request setHTTPBody:postData];
        
        
        NSMutableString *boundary = [NSMutableString stringWithString:@"----Boundary+"];
        for ( int i = 0; i < 5; i++)
        {
            BOOL lowercase = arc4random() % 2;
            
            if(lowercase)
            {
                [boundary appendFormat:@"%c", (arc4random() % 26) + 97];
            } else {
                
                [boundary appendFormat:@"%c", (arc4random() % 26) + 65];
            }
        }
        
        //create the body data
        
        NSMutableData *_body = [NSMutableData data];
        
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [_request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [_body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [_body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\";filename=\"%@%@\"\r\n",filename, filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [_body appendData:[@"Content-Type: txt\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [_body appendData:[NSData dataWithData:filedata]];
        [_body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        // setting the body of the post to the reqeust
        [_request setHTTPBody:_body];
        
        //NSLog(@"Posted file: %@", _body);
        
        // now lets make the connection to the web
        NSError *error = [[NSError alloc] init];
        NSHTTPURLResponse *response = nil;
        NSData *urlData = [NSURLConnection sendSynchronousRequest:_request returningResponse:&response error:&error];
        
        NSLog(@"Response code: %d", [response statusCode]);
        
        if ( [response statusCode] >= 200 && [response statusCode] <300 )
        {
            NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
            NSLog(@"Response ==> %@", responseData);
            SBJsonParser *jsonParser = [SBJsonParser new];
            NSDictionary *jsonData = (NSDictionary *) [jsonParser objectWithString:responseData];
            NSInteger success = [(NSNumber *)[jsonData objectForKey:@"success"] integerValue];
            
            
            if( success == 1)
            {
                [[self class] alertStatus:@"File Uploaded" :@"Success"];
                
            }
            else if ( success == 0)
            {
                [[self class] alertStatus:@"File Could not be uploaded" :@"Error"];
                
            }
            
        }
        
        
    }
    @catch (NSException *e) {
        
        NSLog(@"Caught Exception: %@", e);
    }
    
    
    return nil;
    
}

+(NSString *)uploadEncfile:(NSData *)filedata :(NSString *)filename :(NSString *)userid
{
    //NSInteger randomNumber = arc4random() % 16;
    //NSString *randnumstring = [NSString stringWithFormat:@"%d", randomNumber];
    
    
    
    @try{
        
        NSString *post1 = [NSString stringWithFormat:@"userid=%@&filename=%@", userid, filename];
        NSURL *serviceURL = [NSURL URLWithString:@"http://andysthesis.webhop.org/Php-services/UploadTXT.php"];
        NSData *postData = [post1 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postlength = [NSString stringWithFormat:@"%d", post1.length];
        
        NSMutableURLRequest *_request = [[NSMutableURLRequest alloc] init ];
        
        [_request setURL:serviceURL];
        [_request setHTTPMethod:@"POST"];
        [_request setValue:postlength forHTTPHeaderField:@"Content-Length"];
        [_request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [_request setHTTPBody:postData];
        
        
        NSMutableString *boundary = [NSMutableString stringWithString:@"----Boundary+"];
        for ( int i = 0; i < 5; i++)
        {
            BOOL lowercase = arc4random() % 2;
            
            if(lowercase)
            {
                [boundary appendFormat:@"%c", (arc4random() % 26) + 97];
            } else {
                
                [boundary appendFormat:@"%c", (arc4random() % 26) + 65];
            }
        }
        
        //create the body data
        
        NSMutableData *_body = [NSMutableData data];
        
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [_request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [_body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [_body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\";filename=\"%@%@\"\r\n",filename, filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [_body appendData:[@"Content-Type: txt\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [_body appendData:[NSData dataWithData:filedata]];
        [_body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        // setting the body of the post to the reqeust
        [_request setHTTPBody:_body];
        
        //NSLog(@"Posted file: %@", _body);
        
        // now lets make the connection to the web
        NSError *error = [[NSError alloc] init];
        NSHTTPURLResponse *response = nil;
        NSData *urlData = [NSURLConnection sendSynchronousRequest:_request returningResponse:&response error:&error];
        
        NSLog(@"Response code: %d", [response statusCode]);
        
        if ( [response statusCode] >= 200 && [response statusCode] <300 )
        {
            NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
            NSLog(@"Response ==> %@", responseData);
            SBJsonParser *jsonParser = [SBJsonParser new];
            NSDictionary *jsonData = (NSDictionary *) [jsonParser objectWithString:responseData];
            NSInteger success = [(NSNumber *)[jsonData objectForKey:@"success"] integerValue];
            
            
            if( success == 1)
            {
                [[self class] alertStatus:@"File Uploaded" :@"Success"];
                
            }
            else if ( success == 0)
            {
                [[self class] alertStatus:@"File Could not be uploaded" :@"Error"];
                
            }
            
        }
        
        
    }
    @catch (NSException *e) {
        
        NSLog(@"Caught Exception: %@", e);
    }
    
    
    return nil;
    
}



@end
