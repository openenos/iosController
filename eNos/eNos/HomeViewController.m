//
//  HomeViewController.m
//  eNos
//
//  Created by AMZUR Technologies on 15/08/15.
//  Copyright (c) 2015 AMZUR Technologies. All rights reserved.
//

#import "HomeViewController.h"
#import "eNosAPI.h"
#import "GroupItems.h"
#import "GenericUITableViewCell.h"
#import "SliderUITableViewCell.h"
#import "SwitchUITableViewCell.h"
#import "ColorPickerUITableViewCell.h"
#import "SegmentedUITableViewCell.h"
#import "RollershutterUITableViewCell.h"
#import "ChartUITableViewCell.h"
#import "ImageUITableViewCell.h"
#import "VideoUITableViewCell.h"
#import "WebUITableViewCell.h"
#import "HexColor.h"
#import <MQTTKit.h>
#import "SlideNavigationController.h"
#import "OpenHABSitemap.h"

@interface HomeViewController ()
{
    NSMutableArray *items_list;
    AFHTTPRequestOperation *currentPageOperation;
    AFHTTPRequestOperation *commandOperation;
    UILabel *status_label;
    NSMutableDictionary *channels;
    NSDictionary *menu_dict;
    NSMutableArray *sitemaps;
    NSMutableArray *groupnames;
    NSMutableArray *linkedpages;
    NSMutableArray *inboxData;
    NSIndexPath *setpointIndexpath;
}
@property (strong, nonatomic) dispatch_source_t timer;
@property MQTTClient *client;
@end

@implementation HomeViewController

static NSString * const reuseIdentifier = @"Cell";

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleupdate:) name:@"update" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"update" object:nil];
}

-(void)handleinbox
{
    [self performSegueWithIdentifier:@"inbox" sender:nil];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSString *clientID = [UIDevice currentDevice].identifierForVendor.UUIDString;
    
    UIBarButtonItem *leftbarbutton = [[UIBarButtonItem alloc] initWithTitle:@"Inbox" style:UIBarButtonItemStyleDone target:self action:@selector(handleinbox)];
    
    self.navigationItem.rightBarButtonItem = leftbarbutton;
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDefaultdata:) name:@"reload" object:nil];
    
    self.client = [[MQTTClient alloc] initWithClientId:clientID];
    
    [self.client setMessageHandler:^(MQTTMessage *message){
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:message.payloadString,@"value",message.topic,@"channel",nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"update" object:dict];
        
    }];
    
    [self.client connectToHost:@"192.168.199.40" completionHandler:^(MQTTConnectionReturnCode code) {
        
        if (code == ConnectionAccepted) {
            
            NSLog(@"Client is connected with ID %@",clientID);
            
            [self.client subscribe:@"/enos/out/#" withCompletionHandler:^(NSArray *grantedQos) {
                NSLog(@"Subsribed to Topic");
            }];
            
        }else
        {
            NSLog(@"%lu",(unsigned long)code);
        }
    }];
    
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
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:[NSDictionary dictionaryWithObjectsAndKeys:[groupnames objectAtIndex:0],@"group",[linkedpages objectAtIndex:0],@"page",nil]];
                    
                }else{
                    
                }
                
            }];
            
        } else {
            // Something went wrong, we should have received an array
        }
        
    }];


    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.jpg"]];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    status_label = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height-100)/2, self.view.frame.size.width, 100)];
    status_label.textColor = [UIColor lightGrayColor];
    status_label.textAlignment = NSTextAlignmentCenter;
    status_label.font = [UIFont fontWithName:AVENIR_MEDIUM size:16];
    status_label.backgroundColor = [UIColor clearColor];
    
    [self.tableView.backgroundView addSubview:status_label];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)handleupdate:(NSNotification *)notification
{
    NSDictionary *dict = notification.object;
    NSString *temp1 = [dict objectForKey:@"channel"];
    
    NSString *temp2 = [temp1 stringByReplacingOccurrencesOfString:@"/enos/out/" withString:@""];
    NSString *act_channel;
    
    if ([temp2 containsString:@"_state"]) {
        
        act_channel = [temp2 stringByReplacingOccurrencesOfString:@"_state/state" withString:@""];
        
    }else if ([temp2 containsString:@"_energy"])
    {
        act_channel = [temp2 stringByReplacingOccurrencesOfString:@"_energy/state" withString:@""];
        
    }else if ([temp2 containsString:@"_dimmer"])
    {
        act_channel = [temp2 stringByReplacingOccurrencesOfString:@"_brightness/state" withString:@""];
    }else if ([temp2 containsString:@"_temperature"])
    {
        act_channel = [temp2 stringByReplacingOccurrencesOfString:@"_temperature/state" withString:@""];
    }else if ([temp2 containsString:@"_heat"])
    {
        if ([groupnames containsObject:self.title]) {
            
            act_channel = [temp2 stringByReplacingOccurrencesOfString:@"_heat/state" withString:@""];
        }else
        {
            act_channel = [temp2 stringByReplacingOccurrencesOfString:@"/state" withString:@""];
        }
        
        
    }else if ( [temp2 containsString:@"_cool"])
    {
        if ([groupnames containsObject:self.title]) {
            
            act_channel = [temp2 stringByReplacingOccurrencesOfString:@"_cool/state" withString:@""];
        }else
        {
            act_channel = [temp2 stringByReplacingOccurrencesOfString:@"/state" withString:@""];
        }
        
    }else if ([temp2 containsString:@"_fan"])
    {
        if ([groupnames containsObject:self.title]) {
            
            act_channel = [temp2 stringByReplacingOccurrencesOfString:@"_fan/state" withString:@""];
        }else
        {
            act_channel = [temp2 stringByReplacingOccurrencesOfString:@"/state" withString:@""];
        }
        
    }else if ([temp2 containsString:@"_setpoint"])
    {
        if ([groupnames containsObject:self.title]) {
            
            act_channel = [temp2 stringByReplacingOccurrencesOfString:@"_setpoint/state" withString:@""];
        }else
        {
            act_channel = [temp2 stringByReplacingOccurrencesOfString:@"/state" withString:@""];
        }
        
    }else if ([temp2 containsString:@"_currenttemp"])
    {
        if ([groupnames containsObject:self.title]) {
            
            act_channel = [temp2 stringByReplacingOccurrencesOfString:@"_currenttemp/state" withString:@""];
        }else
        {
            act_channel = [temp2 stringByReplacingOccurrencesOfString:@"/state" withString:@""];
        }
    }
    
    

    
    if ([channels objectForKey:act_channel] != NULL) {
        
        
        GroupItems *group = [items_list objectAtIndex:[[channels objectForKey:act_channel] integerValue]];
        
        
        group.state = [dict objectForKey:@"value"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[[channels objectForKey:act_channel] integerValue] inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        });
     
        
    }
}

-(void)openHABTracked:(NSString *)openHABUrl
{
    
}

-(void)loadDefaultdata:(NSNotification *)sender
{
    
    if(self.navigationItem.leftBarButtonItems.count > 1)
    {
        self.navigationItem.leftBarButtonItems = @[[self.navigationItem.leftBarButtonItems objectAtIndex:1]];
    }
   
    
    channels = [NSMutableDictionary new];
    
    NSDictionary *dict = menu_dict = sender.object;
    
     status_label.text = @"Loading...";
    
    [self.tableView reloadData];
    
    self.title = [dict objectForKey:@"group"];
    
    [[eNosAPI sharedAPI] getGroupItems:[dict objectForKey:@"page"] block:^(id responseObject, NSError *error) {
        
        if (!error) {
            
            @autoreleasepool {
                
                items_list = [NSMutableArray new];
                
                NSArray *memebers = [responseObject objectForKey:@"members"];
                
                for (NSDictionary *memeber in memebers) {
                    
                    NSArray *memebers = [memeber objectForKey:@"members"];
                    
                    GroupItems *groupitem = [[GroupItems alloc] init];
                    
                    NSDictionary *memberdict = [memebers objectAtIndex:0];
                    
                    NSArray *sub_items = [memeber objectForKey:@"members"];
                    
                    NSMutableArray *sub_items_array = [NSMutableArray new];
                    for (NSDictionary *dict in sub_items) {
                        
                        GroupItems *sub_group_items = [[GroupItems alloc] init];
                        
                        [sub_group_items setType:[dict objectForKey:@"type"]];
                        [sub_group_items setLabelValue:[dict objectForKey:@"label"]];
                        [sub_group_items setState:[dict objectForKey:@"state"]];
                        [sub_group_items setLabelText:[dict objectForKey:@"label"]];
                        [sub_group_items setLink:[dict objectForKey:@"link"]];
                        [sub_group_items setChannel:[dict objectForKey:@"name"]];
                        
                        if ([dict objectForKey:@"stateDescription"] != (id)[NSNull null]) {
                            
                            [sub_group_items setPattern:[[dict objectForKey:@"stateDescription"] objectForKey:@"pattern"]];
                        }
                        
                        [sub_items_array addObject:sub_group_items];
                        
                    }
                    
                    [groupitem setSub_items:sub_items_array];
                    [groupitem setType:[memberdict objectForKey:@"type"]];
                    [groupitem setLabelValue:[memberdict objectForKey:@"label"]];
                    [groupitem setState:[memberdict objectForKey:@"state"]];
                    [groupitem setLabelText:[memeber objectForKey:@"label"]];
                    [groupitem setLink:[memeber objectForKey:@"link"]];
                    [groupitem setChannel:[memeber objectForKey:@"name"]];
                    
                    if ([memberdict objectForKey:@"stateDescription"] != (id)[NSNull null]) {
                        
                        [groupitem setPattern:[[memberdict objectForKey:@"stateDescription"] objectForKey:@"pattern"]];
                    }
                    
                    [groupitem setDelegate:self];
                    [items_list addObject:groupitem];
                }
            }
            
//            NSLog(@"%d",items_list.count);
         //
            [self.tableView reloadData];
           // [NSTimer timerWithTimeInterval:6.0 target:self selector:@selector(loadDefaultdata) userInfo:nil repeats:YES];
            //[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(loadDefaultdata) userInfo:nil repeats:YES];
        
            

        }else
        {
            NSLog(@"%@",error);
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UITableViewDeleagteMethods>

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupItems *widget = [items_list objectAtIndex:indexPath.row];
    
    if ([widget.type isEqualToString:@"DimmerItem"]) {
        return 108;
    }else
    {
        return 85;
    }
    
    return 0;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (items_list.count) {
        
       status_label.text = @"";
        return items_list.count;
    }else
    {
      status_label.text = @"No Items";
        return 0;
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GroupItems *widget = [items_list objectAtIndex:indexPath.row];
    
    NSString *cellIdentifier = @"GenericWidgetCell";
    
    if ([widget.type isEqualToString:@"SwitchItem"]) {
        cellIdentifier = @"SwitchWidgetCell";
    } else if ([widget.type isEqualToString:@"Setpoint"]) {
        cellIdentifier = @"SetpointWidgetCell";
    } else if ([widget.type isEqualToString:@"DimmerItem"]) {
        cellIdentifier = @"SliderWidgetCell";
    } else if ([widget.type isEqualToString:@"Selection"]) {
        cellIdentifier = @"SelectionWidgetCell";
    } else if ([widget.type isEqualToString:@"Colorpicker"]) {
        cellIdentifier = @"ColorPickerWidgetCell";
    } else if ([widget.type isEqualToString:@"Chart"]) {
        cellIdentifier = @"ChartWidgetCell";
    } else if ([widget.type isEqualToString:@"Image"]) {
        cellIdentifier = @"ImageWidgetCell";
    } else if ([widget.type isEqualToString:@"Video"]) {
        cellIdentifier = @"VideoWidgetCell";
    } else if ([widget.type isEqualToString:@"Webview"]) {
        cellIdentifier = @"WebWidgetCell";
    }
    
    GenericUITableViewCell *cell = (GenericUITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.callback = self;
    
    if (!cell) {
        cell = [[GenericUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    UISwitch *widgetswitch = (UISwitch *)[cell viewWithTag:200];
    
    
    if (widget.sub_items.count > 1) {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        widgetswitch.hidden = YES;
    }else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        widgetswitch.hidden = NO;
    }
    
    channels[widget.channel] = [NSNumber numberWithInteger:indexPath.row];
    
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.textLabel.textColor = cell.detailTextLabel.textColor = cell.statevalue.textColor = [UIColor whiteColor];
    
    [cell loadWidget:widget];
    [cell displayWidget];
    
    return cell;

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        GroupItems *groupitem = [items_list objectAtIndex:setpointIndexpath.row];
        
        NSString *topic;
        
        if ([groupnames containsObject:self.title]) {
            
            topic = [NSString stringWithFormat:@"/enos/in/%@_state/state",groupitem.channel];
        }else
        {
            topic = [NSString stringWithFormat:@"/enos/in/%@/state",groupitem.channel];
        }

        
        [self.client publishString:[alertView textFieldAtIndex:0].text toTopic:topic withQos:AtMostOnce retain:NO completionHandler:^(int mid) {
            //        NSLog(@"%d",mid);
            //        NSLog(@"Delivered");
        }];
        
        
    }
}

-(void)setpointLabelTapped:(UILabel *)sender andvalue:(NSString *)value
{
    GenericUITableViewCell *cell = (GenericUITableViewCell *)sender.superview.superview;
    setpointIndexpath = [self.tableView indexPathForCell:cell];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.title message:@"Set-point" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save",nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alert textFieldAtIndex:0].text = value;
    [alert textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    
    [alert show];
}

-(void)genericswitchchanged:(UISwitch *)sender
{
    GenericUITableViewCell *cell = (GenericUITableViewCell *)sender.superview.superview;
    
    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
    
    GroupItems *groupitem = [items_list objectAtIndex:indexpath.row];

   
    NSString *string;
    if (sender.isOn) {
        string = @"ON";
    }else
    {
        string = @"OFF";
    }

    NSString *topic;
    
    if ([groupnames containsObject:self.title]) {
        
        topic = [NSString stringWithFormat:@"/enos/in/%@_state/state",groupitem.channel];
    }else
    {
        topic = [NSString stringWithFormat:@"/enos/in/%@/state",groupitem.channel];
    }
    
    [self.client publishString:string toTopic:topic withQos:AtMostOnce retain:NO completionHandler:^(int mid) {
//        NSLog(@"%d",mid);
//        NSLog(@"Delivered");
    }];
}


// OpenHABTracker delegate methods

- (void)openHABTrackingProgress:(NSString *)message
{
    NSLog(@"OpenHABViewController %@", message);
    [TSMessage showNotificationInViewController:self.navigationController title:@"Connecting" subtitle:message image:nil type:TSMessageNotificationTypeMessage duration:3.0 callback:nil buttonTitle:nil buttonCallback:nil atPosition:TSMessageNotificationPositionBottom canBeDismissedByUser:YES];
}

- (void)openHABTrackingError:(NSError *)error
{
    NSLog(@"OpenHABViewController discovery error");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [TSMessage showNotificationInViewController:self.navigationController title:@"Error" subtitle:[error localizedDescription] image:nil type:TSMessageNotificationTypeError duration:60.0 callback:nil buttonTitle:nil buttonCallback:nil atPosition:TSMessageNotificationPositionBottom canBeDismissedByUser:YES];
}



// /send command to an item

- (void)sendCommand:(GroupItems *)item commandToSend:(NSString *)command
{
    NSURL *commandUrl = [[NSURL alloc] initWithString:item.link];
    NSMutableURLRequest *commandRequest = [NSMutableURLRequest requestWithURL:commandUrl];
    [commandRequest setHTTPMethod:@"POST"];
    [commandRequest setHTTPBody:[command dataUsingEncoding:NSUTF8StringEncoding]];
   // [commandRequest setAuthCredentials:self.openHABUsername :self.openHABPassword];
    [commandRequest setValue:@"text/plain" forHTTPHeaderField:@"Content-type"];
    if (commandOperation != nil) {
        [commandOperation cancel];
        commandOperation = nil;
    }
    commandOperation = [[AFHTTPRequestOperation alloc] initWithRequest:commandRequest];
//    AFRememberingSecurityPolicy *policy = [AFRememberingSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//    [policy setDelegate:self];
//    commandOperation.securityPolicy = policy;
//    if (self.ignoreSSLCertificate) {
//        NSLog(@"Warning - ignoring invalid certificates");
//        commandOperation.securityPolicy.allowInvalidCertificates = YES;
//    }
    [commandOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Command sent!");
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Error:------>%@", [error localizedDescription]);
        NSLog(@"error code %ld",(long)[operation.response statusCode]);
    }];
    NSLog(@"Timeout %f", commandRequest.timeoutInterval);
    NSLog(@"OpenHABViewController posting %@ command to %@", command, item.link);
    [commandOperation start];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return UIEdgeInsetsMake(20, 20, 20, 20);
    }else
    {
        return UIEdgeInsetsMake(20, 0, 20, 0);
    }
    
    
}

-(void)handleback:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:menu_dict];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupItems *groupitem = [items_list objectAtIndex:indexPath.row];
    
    if (groupitem.sub_items.count > 1) {
        
//        SubItemsViewController *svc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"sub_items"];
//        
//        svc.items_list = groupitem.sub_items;
//        
//        svc.title = groupitem.labelText;
//        
//        [self.navigationController pushViewController:svc animated:YES];
        
        
//        NSLog(@"%@",self.navigationItem.leftBarButtonItem);
        
        UIBarButtonItem *menu_btn = self.navigationItem.leftBarButtonItem;
        
        UIBarButtonItem *barbuttonitem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(handleback:)];
        
        self.navigationItem.leftBarButtonItems = @[barbuttonitem,menu_btn];
        
        channels = [NSMutableDictionary new];
        
        items_list = [groupitem.sub_items mutableCopy];
        
        self.title = groupitem.labelText;
        
        [self.tableView reloadData];
        
    }else
    {
        return;
    }
}



#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
