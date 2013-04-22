//
//  PhotoViewController.m
//  CloudShareApplication
//
//  Created by Andrew Murphy on 02/04/2013.
//  Copyright (c) 2013 Andrew Murphy. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoCellView.h"
#import "PhotoCellView.h"
#import "LargeImageViewController.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController
{
    NSArray *collectionofimages;
}

@synthesize arrayoffiles;
@synthesize filedirectory;
@synthesize filetitle;
@synthesize userloginID;

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
    
    self.arrayoffiles = [[NSMutableArray alloc] init];
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSDirectoryEnumerator *directoryEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:documentsDirectory];
    
    NSLog(@"Doc Dir: %@", documentsDirectory);
    
    //self.filedirectory = documentsDirectory;
    
    for (NSString *path in directoryEnumerator)
    {
        //check for all image file formats you want to view
        if ([[path pathExtension] isEqualToString:@"jpg"] )
        {
            [self.arrayoffiles addObject:path];
            
        }
    }
    if(self.arrayoffiles.count != 0)
    {
        
        
        //[self.activityindicator stopAnimating];
        //self.gridview.hidden = NO;
        
    }
    
    
    
	// Do any additional setup after loading the view.
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [arrayoffiles count];
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *identifier = @"PhotoCell1";
    
    NSString *title = [self.arrayoffiles objectAtIndex:indexPath.row];
    self.filetitle = title;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *filepath = [NSString stringWithFormat:@"%@/%@", documentsDir, title];
    PhotoCellView *samplecell = ( PhotoCellView * )[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if(samplecell == nil)
    {

        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil];
        samplecell=[nib objectAtIndex:0];
    }
    
    NSLog(@"images: %@", filepath);
    samplecell.pCell.image = [UIImage imageWithContentsOfFile:filepath];
    
    return samplecell;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = [self.arrayoffiles objectAtIndex:indexPath.row];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *filepath = [NSString stringWithFormat:@"%@/%@", documentsDir, title];
    self.filedirectory = filepath;
    [self performSegueWithIdentifier:@"passingfilename" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"passingfilename"]) {
        
        LargeImageViewController *controller = segue.destinationViewController;
        
        controller.filename = self.filetitle;
        
        controller.filepath = self.filedirectory;
    }
}

@end
