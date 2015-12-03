//
//  InboxViewController.h
//  eNos
//
//  Created by Tirupathi on 20/08/15.
//  Copyright (c) 2015 AMZUR Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InboxViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>
//tableview for showing groups.
@property (strong,nonatomic) UITableView *tableview;
@property  NSMutableArray *groupsList;
@end
