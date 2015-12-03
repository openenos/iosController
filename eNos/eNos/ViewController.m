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
#import "InboxModel.h"
#import "InboxViewController.h"
#import <ChameleonFramework/Chameleon.h>
#import <MQTTKit.h>

@interface ViewController ()
{
    CarbonTabSwipeNavigation *tabSwipe;
    NSMutableArray *sitemaps;
    NSMutableArray *groupnames;
    NSMutableArray *linkedpages;
    NSMutableArray *inboxData;
}
@property MQTTClient *client;
@end

@implementation ViewController

#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (void)viewDidLoad {
   
    [super viewDidLoad];
    
    self.title = @"eNOS";
    
       
//    UIImage *image = [[UIImage imageNamed:@"menu"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:nil];
//    
//    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.bgview.backgroundColor = [UIColor clearColor];
    
    sitemaps = [NSMutableArray new];
    groupnames = [NSMutableArray new];
    linkedpages = [NSMutableArray new];
    
    [[eNosAPI sharedAPI] getSitemaps:nil block:^(id responseObject, NSError *error) {
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
           
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
                                [linkedpages addObject:[[widget_obj objectForKey:@"item"] objectForKey:@"link"]];
                                
                            }
                        }
                    }
                    
//                    [self loadTabbar:groupnames];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"menu_update" object:[NSDictionary dictionaryWithObjectsAndKeys:groupnames,@"groups",linkedpages,@"linkedpages",nil]];
                    
                }else{
                    
                }
                
            }];
            
        } else {
            // Something went wrong, we should have received an array
        }

    }];
//    [self loadInBox];
    // Do any additional setup after loading the view, typically from a nib.
}


//-(void)loadInBox
//{
//    
//     inboxData=[NSMutableArray new];
//    InboxModel *inbox=[[InboxModel alloc] init];
//    [inbox setThingId:@"enos:switch:SW004"];
//    [inbox setThingName:@"AC"];
//    [inboxData addObject:inbox];
//
//
////[[eNosAPI sharedAPI] getNewDevice:nil block:^(id responseObject, NSError *error) {
////    if (!error) {
////    
////        
////        if ([responseObject isKindOfClass:[NSArray class]]) {
////            inboxData=[NSMutableArray new];
////            for (NSDictionary *dict in responseObject) {
////                InboxModel *inbox=[[InboxModel alloc] init];
////                [inbox setThingId:[dict objectForKey:@"thingUID"]];
////                [inbox setThingName:[dict objectForKey:@"label"]];
////                [inboxData addObject:inbox];
////
////            }
////        }
////        
////    }else
////    {
////    
////    
////    }
////}];
////    
//    
//}

-(void)loadTabbar:(NSMutableArray *)names
{
    tabSwipe = [[CarbonTabSwipeNavigation alloc] createWithRootViewController:self tabNames:names tintColor:[UIColor clearColor] delegate:self];
    
    [tabSwipe setNormalColor:[UIColor lightGrayColor] font:[UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0f]];
    
    [tabSwipe setSelectedColor:[UIColor whiteColor] font:[UIFont fontWithName:@"AvenirNext-Bold" size:15.0f]];
    
    tabSwipe.view.backgroundColor = [UIColor clearColor];
    
    [tabSwipe setIndicatorHeight:3.f]; // default 3.f
    
    [tabSwipe addShadow];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [tabSwipe setTranslucent:NO]; // remove translucent
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [tabSwipe setTranslucent:YES]; // add translucent
}


# pragma mark - Carbon Tab Swipe Delegate
// required
- (UIViewController *)tabSwipeNavigation:(CarbonTabSwipeNavigation *)tabSwipe viewControllerAtIndex:(NSUInteger)index {

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
        HomeViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"homeview"];
    
//        viewController.pageurl = [linkedpages objectForKey:[groupnames objectAtIndex:index]];
//        viewController.groupname = [groupnames objectAtIndex:index];
    
        return viewController;
}

// optional
- (void)tabSwipeNavigation:(CarbonTabSwipeNavigation *)tabSwipe didMoveAtIndex:(NSInteger)index {
//    NSLog(@"Current tab: %d", (int)index);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([segue.identifier isEqualToString:@"inbox"]) {
//    
//        InboxViewController *inbox=segue.destinationViewController;
////        inbox.inboxInfo=inboxData;
//    }

}
- (IBAction)handleInbox:(id)sender {
    [self performSegueWithIdentifier:@"inbox" sender:nil];
}
@end
