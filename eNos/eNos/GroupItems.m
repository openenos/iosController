//
//  GroupItems.m
//  eNos
//
//  Created by AMZUR Technologies on 15/08/15.
//  Copyright (c) 2015 AMZUR Technologies. All rights reserved.
//

#import "GroupItems.h"

@implementation GroupItems

- (float) stateAsFloat
{
    return [self.state floatValue];
}

- (int) stateAsInt
{
    return (int)[self.state integerValue];
}

-(void)setState:(NSString *)state
{
    if (state != (id)[NSNull null] && ![state isEqualToString:@"NULL"]) {
        _state = state;
    }else
    {
        _state = @"--";
    }
}

- (UIColor*) stateAsUIColor
{
    if ([self.state isEqualToString:@"Uninitialized"]) {
        return [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:1.0];
    } else {
        NSArray *values = [self.state componentsSeparatedByString:@","];
        if ([values count] == 3) {
            CGFloat hue = [(NSString*)[values objectAtIndex:0] floatValue]/360;
            CGFloat saturation = [(NSString*)[values objectAtIndex:1] floatValue]/100;
            CGFloat brightness = [(NSString*)[values objectAtIndex:2] floatValue]/100;
            NSLog(@"%f %f %f", hue, saturation, brightness);
            return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0];
        } else {
            return [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:1.0];
        }
    }
}
@end
