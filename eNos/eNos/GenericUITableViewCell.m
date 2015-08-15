//
//  GenericUITableViewCell.m
//  openHAB
//
//  Created by Victor Belov on 15/01/14.
//  Copyright (c) 2014 Victor Belov. All rights reserved.
//

#import "GenericUITableViewCell.h"
#import "OpenHABLinkedPage.h"

@implementation GenericUITableViewCell
@synthesize widget, textLabel, detailTextLabel, disclosureConstraints;

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.textLabel = (UILabel *)[self viewWithTag:101];
        self.detailTextLabel = (UILabel *)[self viewWithTag:100];
    }
    return self;
}

- (void)loadWidget:(OpenHABWidget *)widgetToLoad
{
    self.widget = widgetToLoad;
    if (widget.linkedPage != nil) {
//        self.userInteractionEnabled = YES;
    } else {
     //        self.userInteractionEnabled = NO;
    }
        
}

- (void)displayWidget
{
    self.textLabel.text = [self.widget labelText];
    if ([self.widget labelValue] != nil)
        self.detailTextLabel.text = [self.widget labelValue];
    else
        self.detailTextLabel.text = nil;
    [self.detailTextLabel sizeToFit];
    // Clean any detailTextLabel constraints we set before, or they will start to interfere with new ones because of UITableViewCell caching
    if (self.disclosureConstraints != nil) {
        [self removeConstraints:disclosureConstraints];
        disclosureConstraints = nil;
    }
    if (self.widget.valuecolor != nil) {
        [self.detailTextLabel setTextColor:[self colorFromHexString:self.widget.valuecolor]];
    } else {
        self.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    if (self.widget.labelcolor != nil) {
        [self.textLabel setTextColor:[self colorFromHexString:self.widget.labelcolor]];
    } else {
        self.textLabel.textColor = [UIColor blackColor];
    }
}

// This is to fix possible different sizes of user icons - we fix size and position of UITableViewCell icons
- (void)layoutSubviews {
    [super layoutSubviews];
//    self.maskView.frame = CGRectMake(13,5,32,32);
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
