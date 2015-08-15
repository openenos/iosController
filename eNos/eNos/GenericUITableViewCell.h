//
//  GenericUITableViewCell.h
//  openHAB
//
//  Created by Victor Belov on 15/01/14.
//  Copyright (c) 2014 Victor Belov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenHABWidget.h"
#import "GroupItems.h"

@interface GenericUITableViewCell : UICollectionViewCell
{
    GroupItems * widget;
}

- (void)loadWidget:(GroupItems *)widgetToLoad;
- (void)displayWidget;

@property (nonatomic, retain) GroupItems *widget;
@property (nonatomic, retain) UILabel *textLabel;
@property (nonatomic, retain) UILabel *detailTextLabel;
@property (nonatomic, retain) UILabel *statevalue;
@property (nonatomic, retain) NSArray *disclosureConstraints;

@end
