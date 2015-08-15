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
@interface HomeViewController : UICollectionViewController<GroupItemsDelegate>
@property NSString *pageurl;
- (void)openHABTracked:(NSString *)openHABUrl;

@end
