//
//  LiveFeedsViewController.h
//  CloudShareApplication
//
//  Created by Andrew on 27/03/2013.
//  Copyright (c) 2013 Andrew Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveFeedsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    UIActivityIndicatorView *_activityIndicator;
    NSArray *_liveFeed;
}


@property ( nonatomic, retain ) UITableView *tableview;
@property ( nonatomic, retain ) UIActivityIndicatorView *activityindicator;
@property ( nonatomic, retain ) NSArray *livefeeds;
- (IBAction)Reloadtable:(id)sender;
@end
