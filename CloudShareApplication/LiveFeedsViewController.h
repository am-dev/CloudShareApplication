//
//  LiveFeedsViewController.h
//  CloudShareApplication
//
//  Created by Andrew on 27/03/2013.
//  Copyright (c) 2013 Andrew Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveFeedsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
{
    UITableView *_tableView;
    UIActivityIndicatorView *_activityIndicator;
    NSArray *_liveFeed;
    NSString *_userid;
    NSString *fileid;
}


@property ( nonatomic, retain ) UITableView *tableview;
@property ( nonatomic, retain ) UIActivityIndicatorView *activityindicator;
@property ( nonatomic, retain ) NSArray *livefeeds;
@property ( nonatomic, retain ) NSString *userid;
@property ( nonatomic, retain ) NSString *fileid;

- (IBAction)Reloadtable:(id)sender;
@end
