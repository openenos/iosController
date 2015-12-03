//
//  ThingsCell.h
//  eNos
//
//  Created by AMZUR Technologies on 30/11/15.
//  Copyright © 2015 AMZUR Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"
@interface ThingsCell : MGSwipeTableCell

@property (weak, nonatomic) IBOutlet UILabel *logo_label;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *type;
@end
