//
//  HomeViewController.h
//  eNos
//
//  Created by AMZUR Technologies on 15/08/15.
//  Copyright (c) 2015 AMZUR Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupItems.h"
#import <TSMessage.h>
#import "SlideNavigationController.h"
#import "GenericUITableViewCell.h"
@interface HomeViewController : UITableViewController<GroupItemsDelegate,SlideNavigationControllerDelegate,GenericCellDelegate>
@property NSString *pageurl;
@property NSString *groupname;
- (void)openHABTracked:(NSString *)openHABUrl;

@end
