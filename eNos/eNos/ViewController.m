//
//  ViewController.m
//  eNos
//
//  Created by AMZUR Technologies on 15/08/15.
//  Copyright (c) 2015 AMZUR Technologies. All rights reserved.
//

#import "ViewController.h"
#import "CarbonKit.h"
#import "HomeViewController.h"
#import "HexColor.h"
@interface ViewController ()
{
    CarbonTabSwipeNavigation *tabSwipe;
    NSArray *names;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"eNos";
    
    names = @[@"Telugu",@"Hindi",@"Malayalam",@"Tamil"];
    
    tabSwipe = [[CarbonTabSwipeNavigation alloc] createWithRootViewController:self tabNames:names tintColor:[UIColor colorWithHexString:@"#F60"] delegate:self];
    
    [tabSwipe setNormalColor:[UIColor lightGrayColor] font:[UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0f]];
    
    [tabSwipe setSelectedColor:[UIColor whiteColor] font:[UIFont fontWithName:@"AvenirNext-Bold" size:15.0f]];
    
    tabSwipe.view.backgroundColor = [UIColor colorWithHexString:@"#F60"];
    
    [tabSwipe setIndicatorHeight:3.f]; // default 3.f
    
    [tabSwipe addShadow];

    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [tabSwipe setTranslucent:NO]; // remove translucent
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [tabSwipe setTranslucent:YES]; // add translucent
}


# pragma mark - Carbon Tab Swipe Delegate
// required
- (UIViewController *)tabSwipeNavigation:(CarbonTabSwipeNavigation *)tabSwipe viewControllerAtIndex:(NSUInteger)index {

        HomeViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"homeview"];
        return viewController;
}

// optional
- (void)tabSwipeNavigation:(CarbonTabSwipeNavigation *)tabSwipe didMoveAtIndex:(NSInteger)index {
    NSLog(@"Current tab: %d", (int)index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
