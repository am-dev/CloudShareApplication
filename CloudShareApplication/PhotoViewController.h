//
//  PhotoViewController.h
//  CloudShareApplication
//
//  Created by Andrew Murphy on 02/04/2013.
//  Copyright (c) 2013 Andrew Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UICollectionViewController

@property (nonatomic, retain) NSMutableArray *arrayoffiles;
@property (nonatomic, retain) NSString *filedirectory;
@property (nonatomic, retain) NSString *filetitle;

@end
