//
//  SelectedFeedViewController.h
//  CloudShareApplication
//
//  Created by Andrew Murphy on 04/04/2013.
//  Copyright (c) 2013 Andrew Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedFeedViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

{
    UITableView *_tableView;
    
    NSString *_fileid;
    
    NSArray *_filecomments;
}


@property (nonatomic, retain) NSString *fileid;

@property (nonatomic, retain) NSArray *filecomments;

@property (nonatomic, retain) UITableView *tableview;

@end