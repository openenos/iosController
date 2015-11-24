//
//  InboxViewController.h
//  eNos
//
//  Created by Tirupathi on 20/08/15.
//  Copyright (c) 2015 AMZUR Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InboxViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>
//to store inbox information
@property NSMutableArray *inboxInfo;
//tableview for showing groups.
@property (strong,nonatomic) UITableView *tableview;
@end
