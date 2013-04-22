//
//  LargeImageViewController.m
//  CloudShareApplication
//
//  Created by Andrew Murphy on 04/04/2013.
//  Copyright (c) 2013 Andrew Murphy. All rights reserved.
//

#import "LargeImageViewController.h"
#import "SBJson.h"

@interface LargeImageViewController ()

@end

@implementation LargeImageViewController
@synthesize largeimage = _largeimage;
@synthesize filenamelabel = _filenamelabel;
@synthesize filepath = _filepath;
@synthesize filename = _filename;
@synthesize userid;


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
    
    NSString *path = self.filepath;
    NSLog(@"Filepath :%@", path);
    _largeimage.image = [UIImage imageWithContentsOfFile:path];
    _filenamelabel.text = self.filename;
    // Do any additional setup after loading the view.
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)uploadselected:(id)sender

{
    NSData *data = [[NSData alloc] initWithContentsOfFile:self.filepath];
    
    NSString *user = @"";
    
    user = [user stringByAppendingFormat:@"%@.", self.userid];
    
    [[self class] uploadfile:data :self.filename :user];
    
}

+(NSString *)uploadfile:(NSData *)filedata :(NSString *)filename :(NSString *)userid
{
    //NSInteger randomNumber = arc4random() % 16;
    //NSString *randnumstring = [NSString stringWithFormat:@"%d", randomNumber];
    
    @try{
        
        NSString *post1 = [NSString stringWithFormat:@"userid=%@&filename=%@", userid, filename];
        NSURL *serviceURL = [NSURL URLWithString:@"http://andysthesis.webhop.org/Php-services/UploadIMAGE.php"];
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
        [_body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\";filename=\"%@%@\"\r\n",userid,filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [_body appendData:[@"Content-Type: jpg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
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
            else
            {
                NSLog(@"Nope");
            }
            
        }
        
        
    }
    @catch (NSException *e) {
        
        NSLog(@"Caught Exception: %@", e);
    }
    
    
    return nil;
    
}

@end
