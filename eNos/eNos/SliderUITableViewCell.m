//
//  SliderUITableViewCell.m
//  openHAB
//
//  Created by Victor Belov on 16/01/14.
//  Copyright (c) 2014 Victor Belov. All rights reserved.
//

#import "SliderUITableViewCell.h"
#import "OpenHABWidget.h"
#import "OpenHABItem.h"

@implementation SliderUITableViewCell
@synthesize widgetSlider;

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.widgetSlider = (UISlider *)[self viewWithTag:400];
        self.widget_switch = (UISwitch *)[self viewWithTag:500];
    }
    return self;
}

- (void)displayWidget
{
    self.textLabel.text = [self.widget labelText];
    float widgetValue = [widget stateAsFloat];
    [self.widgetSlider setValue:widgetValue/100];
    self.detailTextLabel.text = self.widget.labelValue;
    self.statevalue.text = [NSString stringWithFormat:@"%d",(int)widgetValue];
    [self.widgetSlider addTarget:self
                  action:@selector(sliderDidEndSliding:)
        forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventValueChanged)];
    int intValue_ = self.widgetSlider.value * 100;
    self.statevalue.text=[NSString stringWithFormat:@"%d%%",intValue_];
    
    if (widgetValue > 0) {
        
        [self.widget_switch setOn:YES];
    }else
    {
        [self.widget_switch setOn:NO];
    }
    
    [self.widget_switch addTarget:self action:@selector(switch_changed:) forControlEvents:UIControlEventValueChanged];
    
}

-(void)switch_changed:(UISwitch *)_switch
{
    if (_switch.isOn) {
        self.widgetSlider.value = 100.0f;
    }else
    {
        self.widgetSlider.value = 0.0f;
    }
    
    [self sliderDidEndSliding:nil];
}

- (void)sliderDidEndSliding:(NSNotification *)notification {
//    NSLog(@"Slider new value = %f", self.widgetSlider.value);
    int intValue = self.widgetSlider.value * 100;
    if (intValue == 0) {
        
        self.widget_switch.on = 0;
    }else if(intValue == 100)
    {
        self.widget_switch.on = 1;
    }
//    [self.widget sendCommand:[NSString stringWithFormat:@"%d", intValue]];
    self.statevalue.text=[NSString stringWithFormat:@"%d%%",intValue];
    [self.widget sendCommand:[NSString stringWithFormat:@"%d", intValue]];
}

@end
