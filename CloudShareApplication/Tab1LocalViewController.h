//
//  Tab1LocalViewController.h
//  CloudShareApplication
//
//  Created by Andrew on 20/03/2013.
//  Copyright (c) 2013 Andrew Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Tab1LocalViewController : UIViewController

{
    NSString *userid;
}

@property ( nonatomic ) NSString *userid;


-(IBAction)mp3playerselected:(id)sender;
-(IBAction)imagepickerselected:(id)sender;
-(IBAction)texteditorselected:(id)sender;

@end
