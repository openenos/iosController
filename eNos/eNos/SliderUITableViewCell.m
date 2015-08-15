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
    }
    return self;
}

- (void)displayWidget
{
    self.textLabel.text = [self.widget labelText];
    float widgetValue = [widget stateAsFloat];
    [self.widgetSlider setValue:widgetValue/100];
    [self.widgetSlider addTarget:self
                  action:@selector(sliderDidEndSliding:)
        forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventValueChanged)];
    int intValue_ = self.widgetSlider.value * 100;
    self.statevalue.text=[NSString stringWithFormat:@"%d%%",intValue_];
}
- (void)sliderDidEndSliding:(NSNotification *)notification {
    NSLog(@"Slider new value = %f", self.widgetSlider.value);
    int intValue = self.widgetSlider.value * 100;
    self.statevalue.text=[NSString stringWithFormat:@"%d%%",intValue];
    [self.widget sendCommand:[NSString stringWithFormat:@"%d", intValue]];
}

@end
