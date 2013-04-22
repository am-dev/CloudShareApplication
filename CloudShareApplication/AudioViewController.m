//
//  ViewController.m
//  TestAudioFileHandler
//
//  Created by Andrew on 11/03/2013.
//  Copyright (c) 2013 Andrew Murphy. All rights reserved.
//

#import "AudioViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SBJson.h"
#import "AESCrypt.h"
#import "NSData+CommonCrypto.h"
#import "NSData+Base64.h"
#import "LoginViewController.h"

@interface AudioViewController ()

@end

@implementation AudioViewController
@synthesize urlselected = _urlselected;
@synthesize activityindicator = _activityindicator;
@synthesize arrayoffiles = _arrayoffiles;
@synthesize tableview = _tableview;

@synthesize Mp3ImageHolder = _Mp3ImageHolder;
@synthesize PlayButton = _PlayButton;
@synthesize StopButton = _StopButton;
@synthesize FFButton = _FFButton;
@synthesize RWButton = _RWButton;
@synthesize player = _player;
@synthesize openlistofmp3 = _openlistofmp3;
@synthesize volumeslider = _volumeslider;
@synthesize shareButton = _shareButton;
@synthesize userloginID = _userloginID;
@synthesize Title;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    NSLog(@"id: %@", _userloginID);
    
    self.arrayoffiles = [[NSMutableArray alloc] init];
    
    //NSError *error2;
    //self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error2];
    
    [self.player prepareToPlay];
    
    
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

- (void)openlistofmp3:(id)sender
{
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width,self.view.bounds.size.height) style:UITableViewStylePlain];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableview.hidden = YES;
    [self.view addSubview:self.tableview];
    
    //set up activity indicator view
    
    self.activityindicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityindicator.hidesWhenStopped = YES;
    self.activityindicator.center = self.view.center;
    [self.view addSubview:self.activityindicator];
    [self.activityindicator startAnimating];
    
    // initializing the data source
    self.arrayoffiles = [[NSMutableArray alloc] init];
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSDirectoryEnumerator *directoryEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:documentsDirectory];
    
    //NSLog(@"Doc Dir: %@", documentsDirectory);
    
    for (NSString *path in directoryEnumerator)
    {
        //check for all music file formats you need to play
        if ([[path pathExtension] isEqualToString:@"mp3"] || [[path pathExtension] isEqualToString:@"aiff"] )
        {
            [self.arrayoffiles addObject:path];
        }
    }
    
    if(self.arrayoffiles.count != 0)
    {
        
        [self.activityindicator stopAnimating];
        self.tableview.hidden = NO;
        
    }
    
    NSLog(@"User login id %@", userloginID);
}

- (void)PlayPressed:(id)sender
{
    //self.player.currentTime = 0;
    if(![self.player play])
    {
        [self.player play];
    }
    else if ([self.player play])
    {
        
    }
}

-(void)StopPressed:(id)sender
{
    [self.player stop];
}

-(void)FFPressed:(id)sender
{
    [self.player pause];
}

-(void)RWPressed:(id)sender
{
    
}

-(void)volumechanged:(id)sender
{
    if(self.player !=nil)
    {
        self.player.volume = _volumeslider.value;
    }
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *cellid = @"Cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if ( cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
    
    
    
    //NSDictionary *files = [self.arrayoffiles objectAtIndex:indexPath.row];
    cell.textLabel.text = [self.arrayoffiles objectAtIndex:indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //cell.accessoryType = UITableViewCellAccessoryCheckmark;
    NSString *cellText = cell.textLabel.text;
    NSString *cellText2 = [cellText stringByDeletingPathExtension];
    
    self.Title = cellText;
    
    NSString *filepath = [[NSBundle mainBundle] pathForResource:cellText2 ofType:@"mp3"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filepath];
    self.urlselected = fileURL;
    
    AVAsset *asset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
    
    NSArray *metadata = [asset commonMetadata];
    
    for ( AVMetadataItem* item in metadata )
    {
        NSString *key = [item commonKey];
        NSString *value = [item stringValue];
        NSLog(@"key = %@, value = %@", key, value);
    }
    
    NSError *error2;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error2];
    [self.player play];
    self.tableview.hidden = YES;
    
    
}

-(IBAction)sharebuttonselected:(id)sender
{
    
    NSData *data2 = [[NSData alloc] initWithContentsOfURL:self.urlselected];
    //NSData *data = [[[NSData alloc] initWithData:data2] AES256EncryptedDataUsingKey:@"test" error:nil];
    
    
     
    NSString *certPath = [[NSBundle mainBundle] pathForResource:@"public_key" ofType:@"der"];
    
    SecCertificateRef myCertificate = nil;
    
    NSData *certificateData = [[NSData alloc] initWithContentsOfFile:certPath];
    
    myCertificate = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)certificateData);
    
    SecPolicyRef myPolicy = SecPolicyCreateBasicX509();
    
    SecTrustRef myTrust;
    
    SecTrustCreateWithCertificates(myCertificate, myPolicy, &myTrust);
    
    SecKeyRef publicKey = SecTrustCopyPublicKey(myTrust);
    
    NSLog(@"Public Key: %@", publicKey);
    
    NSLog(@"Url selected: %@", self.urlselected);
    
    NSString *string = self.Title;
    
    string = [string stringByAppendingFormat:@"%@.mp3", string];
    
    NSString *user = self.userloginID;
    
    [[self class] uploadfile:data2 :string :user];
}

+(NSString *)uploadfile:(NSData *)filedata :(NSString *)filename :(NSString *)userid
{
    
    NSInteger randomNumber = arc4random() % 16;
    
    NSString *randnumstring = [NSString stringWithFormat:@"%d", randomNumber];

    
    @try{
        
        NSString *post1 = [NSString stringWithFormat:@"userid=%@&filename=%@", userid, filename];
        
        NSURL *serviceURL = [NSURL URLWithString:@"http://andysthesis.webhop.org/Php-services/UploadMP3.php"];
        
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
        [_body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\";filename=\"%@%@\"\r\n",randnumstring,filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [_body appendData:[@"Content-Type: mp3\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [_body appendData:[NSData dataWithData:filedata]];
        [_body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        // setting the body of the post to the reqeust
        [_request setHTTPBody:_body];
        
        // now we make the connection to the web
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
