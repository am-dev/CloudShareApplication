//
//  TextEditViewController.m
//  CloudShareApplication
//
//  Created by Andrew on 01/04/2013.
//  Copyright (c) 2013 Andrew Murphy. All rights reserved.
//

#import "TextEditViewController.h"

@interface TextEditViewController ()

@end

@implementation TextEditViewController
@synthesize textcontent = _textcontent;
@synthesize texttitle = _texttitle;
@synthesize urlselected = _urlselected;
@synthesize tableview = _tableview;
@synthesize arrayoffiles = _arrayoffiles;

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
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    
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

- (IBAction)BackgroundClick:(id)sender
{
    [_textcontent resignFirstResponder];
    [_texttitle resignFirstResponder];
    
}
- (IBAction)savetextButton:(id)sender {
    
    NSString *titleString = self.texttitle.text;
    titleString = [titleString stringByAppendingPathExtension:@"txt"];
    NSString *ContentString = self.textcontent.text;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *filepath = [NSString stringWithFormat:@"%@/%@", documentsDir, titleString];
    
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:filepath])
    {
        //NSString *ContentString = self.textcontent.text;
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

- (IBAction)ShareButtonSelected:(id)sender
{
    
}

- (IBAction)loadlocalfiles:(id)sender
{
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width,self.view.bounds.size.height) style:UITableViewStylePlain];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableview.hidden = YES;
    [self.view addSubview:self.tableview];
    
    //set up activity indicator view
    /*
    self.activityindicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityindicator.hidesWhenStopped = YES;
    self.activityindicator.center = self.view.center;
    [self.view addSubview:self.activityindicator];
    [self.activityindicator startAnimating];
    */
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
@end
