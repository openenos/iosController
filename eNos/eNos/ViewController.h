//
//  ViewController.h
//  eNos
//
//  Created by AMZUR Technologies on 15/08/15.
//  Copyright (c) 2015 AMZUR Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
@interface ViewController : UIViewController<SlideNavigationControllerDelegate>

- (IBAction)handleInbox:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *bgview;

@end

