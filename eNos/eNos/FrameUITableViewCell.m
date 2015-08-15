//
//  FrameUITableViewCell.m
//  openHAB
//
//  Created by Victor Belov on 15/01/14.
//  Copyright (c) 2014 Victor Belov. All rights reserved.
//

#import "FrameUITableViewCell.h"
#import "OpenHABWidget.h"

@implementation FrameUITableViewCell
@synthesize textLabel;

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.textLabel = (UILabel *)[self viewWithTag:100];
    }
    return self;
}

- (void)displayWidget
{
    self.textLabel.text = [self.widget.label uppercaseString];
    [self.contentView sizeToFit];
}

@end
