//
//  GenericUITableViewCell.m
//  openHAB
//
//  Created by Victor Belov on 15/01/14.
//  Copyright (c) 2014 Victor Belov. All rights reserved.
//

#import "GenericUITableViewCell.h"
#import "OpenHABLinkedPage.h"
#import "GroupItems.h"
@implementation GenericUITableViewCell
@synthesize widget, textLabel, detailTextLabel, disclosureConstraints;

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.textLabel = (UILabel *)[self viewWithTag:101];
        self.detailTextLabel = (UILabel *)[self viewWithTag:100];
        self.statevalue = (UILabel *)[self viewWithTag:102];
        self.image_icon = (UIImageView *)[self viewWithTag:104];
    }
    return self;
}

- (void)loadWidget:(GroupItems *)widgetToLoad
{
    self.widget = widgetToLoad;
//    if (widget.linkedPage != nil) {
////        self.userInteractionEnabled = YES;
//    } else {
//     //        self.userInteractionEnabled = NO;
//    }
    
}

- (void)displayWidget
{
    self.textLabel.text = [self.widget labelText];
    

    if ([self.widget labelValue] != nil)
        self.detailTextLabel.text = [self.widget labelValue];
    else
        self.detailTextLabel.text = nil;
    
    NSArray *array = [self.widget.pattern componentsSeparatedByString:@" "];
    
    self.statevalue.text = [NSString stringWithFormat:@"%@ %@",self.widget.state,[array objectAtIndex:1]];
    
    if ([self.detailTextLabel.text isEqualToString:@"Set-Point"]) {
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlesetpointTap:)];
        gesture.numberOfTapsRequired = 1;
        self.statevalue.userInteractionEnabled = YES;
        [self.statevalue addGestureRecognizer:gesture];
    }
    
    if ([self.widget.labelText isEqualToString:@"Building Energy"]) {
        
        self.image_icon.image = [[UIImage imageNamed:@"energy.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.image_icon.tintColor = [UIColor greenColor];
        
    }else if ([self.widget.labelText isEqualToString:@"Temperature"])
    {
        self.image_icon.image = [[UIImage imageNamed:@"current_temparature.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.image_icon.tintColor = [UIColor greenColor];
    }else if ([self.widget.labelText isEqualToString:@"Cool"])
    {
        self.image_icon.image = [[UIImage imageNamed:@"cool.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            self.image_icon.tintColor = [UIColor greenColor];
        
    }else if ([self.widget.labelText isEqualToString:@"Fan"])
    {
        self.image_icon.image = [[UIImage imageNamed:@"fan.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
       self.image_icon.tintColor = [UIColor greenColor];
        
    }else if ([self.widget.labelText isEqualToString:@"Heat"])
    {
        self.image_icon.image = [[UIImage imageNamed:@"heat.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.image_icon.tintColor = [UIColor greenColor];
    }else if ([self.widget.labelText isEqualToString:@"Set-Point"])
    {
        self.image_icon.image = [[UIImage imageNamed:@"setpoint.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.image_icon.tintColor = [UIColor greenColor];
    }else if ([self.widget.labelText isEqualToString:@"Current Temp"])
    {
        self.image_icon.image = [[UIImage imageNamed:@"current_temparature.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.image_icon.tintColor = [UIColor greenColor];
    }

    
    self.image_icon.clipsToBounds = YES;
    
    [self.detailTextLabel sizeToFit];

}

-(void)handlesetpointTap:(UITapGestureRecognizer *)gesture
{
    [self.callback setpointLabelTapped:(UILabel *)gesture.view andvalue:self.widget.state];
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
