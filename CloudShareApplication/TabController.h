//
//  TabController.h
//  CloudShareApplication
//
//  Created by Andrew Murphy on 04/04/2013.
//  Copyright (c) 2013 Andrew Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabController : UITabBarController <UITabBarControllerDelegate, UITabBarDelegate>
{
    NSString *userid_login;
}

@property ( nonatomic, retain ) NSString *userid_loginid;

@end
