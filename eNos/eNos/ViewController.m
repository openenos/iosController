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
#import "eNosAPI.h"
#import "OpenHABSitemap.h"
@interface ViewController ()
{
    CarbonTabSwipeNavigation *tabSwipe;
    NSMutableArray *sitemaps;
    NSMutableArray *groupnames;
    NSMutableDictionary *linkedpages;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"eNos";
    
    sitemaps = [NSMutableArray new];
    groupnames = [NSMutableArray new];
    linkedpages = [NSMutableDictionary new];
    
    [[eNosAPI sharedAPI] getSitemaps:nil block:^(id responseObject, NSError *error) {
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSLog(@"Response is array");
            for (id sitemapJson in responseObject) {
                OpenHABSitemap *sitemap = [[OpenHABSitemap alloc] initWithDictionaty:sitemapJson];
                [sitemaps addObject:sitemap];
            }
            
            NSString *url = [[sitemaps objectAtIndex:0] homepageLink];
            
            [[eNosAPI sharedAPI] getGroups:url block:^(id responseObject, NSError *error) {
                
                if (!error) {
                    
                    NSArray *widgets = [responseObject objectForKey:@"widgets"];
                    
                    for (NSDictionary *object in widgets) {
                        
                        if ([[object objectForKey:@"type"] isEqualToString:@"Frame"] && [[object objectForKey:@"label"] isEqualToString:@""]) {
                            
                            NSArray *widgets = [object objectForKey:@"widgets"];
                            
                            for (NSDictionary *widget_obj in widgets) {
                                
                                [groupnames addObject:[widget_obj objectForKey:@"label"]];
                                [linkedpages setObject:[[widget_obj objectForKey:@"item"] objectForKey:@"link"] forKey:[widget_obj objectForKey:@"label"]];
                                
                            }
                        }
                    }
                    
                    [self loadTabbar:groupnames];
                    
                }else{
                    
                }
                
            }];
            
        } else {
            // Something went wrong, we should have received an array
        }

    }];

    // Do any additional setup after loading the view, typically from a nib.
}

-(void)loadTabbar:(NSMutableArray *)names
{
    tabSwipe = [[CarbonTabSwipeNavigation alloc] createWithRootViewController:self tabNames:names tintColor:[UIColor colorWithHexString:@"#F60"] delegate:self];
    
    [tabSwipe setNormalColor:[UIColor lightGrayColor] font:[UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0f]];
    
    [tabSwipe setSelectedColor:[UIColor whiteColor] font:[UIFont fontWithName:@"AvenirNext-Bold" size:15.0f]];
    
    tabSwipe.view.backgroundColor = [UIColor colorWithHexString:@"#F60"];
    
    [tabSwipe setIndicatorHeight:3.f]; // default 3.f
    
    [tabSwipe addShadow];
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
    
//        viewController.pageUrl = [linkedpages objectForKey:[groupnames objectAtIndex:index]];
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
