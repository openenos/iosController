//
//  GroupItems.h
//  eNos
//
//  Created by AMZUR Technologies on 15/08/15.
//  Copyright (c) 2015 AMZUR Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class GDataXMLElement;
@class GroupItems;
@protocol GroupItemsDelegate <NSObject>
- (void)sendCommand:(GroupItems *)item commandToSend:(NSString *)command;
@end

@interface GroupItems : NSObject
@property NSString *type;
@property(nonatomic,strong) NSString *state;
@property NSString *labelText;
@property NSString *labelValue;
@property NSString *pattern;
@property NSString *link;
@property(nonatomic, strong) NSString *channel;
- (float) stateAsFloat;
- (int) stateAsInt;
- (UIColor*) stateAsUIColor;
- (NSString *) labelText;
- (NSString *) labelValue;
- (void) sendCommand:(NSString *)command;
@property id<GroupItemsDelegate> delegate;
@end
