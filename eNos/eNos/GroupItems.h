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
@interface GroupItems : NSObject
@property NSString *itemtype;
@property NSString *state;
@property NSString *title;
@property NSString *label;
- (float) stateAsFloat;
- (int) stateAsInt;
- (UIColor*) stateAsUIColor;
@end
