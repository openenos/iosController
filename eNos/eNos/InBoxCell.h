//
//  InBoxCell.h
//  eNos
//
//  Created by Tirupathi on 20/08/15.
//  Copyright (c) 2015 AMZUR Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InBoxCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *thinkName;
@property (weak, nonatomic) IBOutlet UILabel *thingId;
@property (weak, nonatomic) IBOutlet UIButton *ignoreButton;
@property (weak, nonatomic) IBOutlet UIButton *approveButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end
