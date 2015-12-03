//
//  SwitchUITableViewCell.m
//  openHAB
//
//  Created by Victor Belov on 16/01/14.
//  Copyright (c) 2014 Victor Belov. All rights reserved.
//

#import "SwitchUITableViewCell.h"
#import "OpenHABWidget.h"
#import "GroupItems.h"

@implementation SwitchUITableViewCell
@synthesize widgetSwitch;

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.widgetSwitch = (UISwitch *)[self viewWithTag:200];
        [self.widgetSwitch addTarget:self action:@selector(handleswitch:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

-(void)handleswitch:(UISwitch *)sender
{
    [self.callback genericswitchchanged:sender];
}

- (void)displayWidget
{
    self.textLabel.text = [self.widget labelText];
    
    if ([self.widget labelValue] != nil)
        self.detailTextLabel.text = [self.widget labelValue];
    else
        self.detailTextLabel.text = nil;
    if ([self.widget.state isEqualToString:@"ON"]) {
        [self.widgetSwitch setOn:YES];
    } else {
        [self.widgetSwitch setOn:NO];
    }
    
     [self setimages];
    
//    NSLog(@"%f %f %f %f", self.textLabel.frame.origin.x, self.textLabel.frame.origin.y, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
    [self.widgetSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
}

- (void)switchChange:(id)sender{
//    if (self.widgetSwitch.isOn) {
//        NSLog(@"Switch to ON");
//        [self.widget sendCommand:@"ON"];
//    } else {
//        NSLog(@"Switch to OFF");
//        [self.widget sendCommand:@"OFF"];
//    }
    
    [self setimages];
}

-(void)setimages
{
    if ([self.widget.labelText isEqualToString:@"Lights"] || [self.widget.labelText isEqualToString:@"Light Dimmer"]) {
        
        if (self.widgetSwitch.isOn) {
            self.image_icon.image = [UIImage imageNamed:@"on_light.png"];
        }else{
            self.image_icon.image = [UIImage imageNamed:@"off_light.png"];
        }
        
    }else if ([self.widget.labelText isEqualToString:@"Refrigerator"])
    {
        
        self.image_icon.image = [[UIImage imageNamed:@"refrigirator.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        if (self.widgetSwitch.isOn) {
            self.image_icon.tintColor = [UIColor greenColor];
        }else
        {
            self.image_icon.tintColor = [UIColor grayColor];
        }
        
    }else if ([self.widget.labelText isEqualToString:@"Toaster"])
    {
        
        self.image_icon.image = [[UIImage imageNamed:@"toaster.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        if (self.widgetSwitch.isOn) {
            self.image_icon.tintColor = [UIColor greenColor];
        }else
        {
            self.image_icon.tintColor = [UIColor grayColor];
        }
        
    }else if ([self.widget.labelText isEqualToString:@"Washing Machine"])
    {
        self.image_icon.image = [[UIImage imageNamed:@"washing_machine.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        if (self.widgetSwitch.isOn) {
            self.image_icon.tintColor = [UIColor greenColor];
        }else
        {
            self.image_icon.tintColor = [UIColor grayColor];
        }
        
    }else if ([self.widget.labelText isEqualToString:@"Dish Washer"])
    {
        self.image_icon.image = [[UIImage imageNamed:@"dish_washer.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        if (self.widgetSwitch.isOn) {
            self.image_icon.tintColor = [UIColor greenColor];
        }else
        {
            self.image_icon.tintColor = [UIColor grayColor];
        }
        
    }else if([self.widget.labelText isEqualToString:@"HVAC"]){
        
        self.image_icon.image = [[UIImage imageNamed:@"ac.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        if (self.widgetSwitch.isOn) {
            self.image_icon.tintColor = [UIColor greenColor];
        }else
        {
            self.image_icon.tintColor = [UIColor grayColor];
        }
    }

}

@end
