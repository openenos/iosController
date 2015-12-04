//
//  ThingsViewController.m
//  eNos
//
//  Created by AMZUR Technologies on 30/11/15.
//  Copyright © 2015 AMZUR Technologies. All rights reserved.
//

#import "ThingsViewController.h"
#import "ThingsCell.h"
#import "Things.h"
#import "eNosAPI.h"
#import "SlideNavigationContorllerAnimator.h"
#import "MGSwipeButton.h"
#import <ChameleonFramework/Chameleon.h>
#import "MGSwipeTableCell.h"
@interface ThingsViewController ()<MGSwipeTableCellDelegate>
{
    UILabel *status_label;
}
@property NSMutableArray *things;
@end

@implementation ThingsViewController

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Things";
    
    self.things = [NSMutableArray new];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.jpg"]];
    
    status_label = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height-100)/2, self.view.frame.size.width, 100)];
    status_label.textColor = [UIColor lightGrayColor];
    status_label.textAlignment = NSTextAlignmentCenter;
    status_label.font = [UIFont fontWithName:AVENIR_MEDIUM size:16];
    status_label.backgroundColor = [UIColor clearColor];
    status_label.text = @"Loading...";
    
    [self.tableView reloadData];
    
    [self.tableView.backgroundView addSubview:status_label];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(AddThing:)];
    
    
    [[eNosAPI sharedAPI] getAllThings:@"" block:^(id responseObject, NSError *error) {
        
        if (error) {
            
        }else if ([responseObject isKindOfClass:[NSArray class]])
        {
         
            NSArray *array = responseObject;
            
            for (NSDictionary *dict in array) {
                
                Things *thing = [Things new];
                
                thing.name = [[dict objectForKey:@"item"] objectForKey:@"label"];
                thing.UID = [dict objectForKey:@"UID"];
                thing.item_type = [[[dict objectForKey:@"channels"] objectAtIndex:0] objectForKey:@"itemType"];
                thing.status_info = [[dict objectForKey:@"statusInfo"] objectForKey:@"status"];
                thing.switch_id = [[dict objectForKey:@"configuration"] objectForKey:@"switchId"];
                thing.device_id = [[dict objectForKey:@"configuration"] objectForKey:@"deviceId"];
                
                [self.things addObject:thing];
            }
            
            [self.tableView reloadData];
            
        }else
        {
            
        }
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

-(void)AddThing:(id)sender
{
    [self performSegueWithIdentifier:@"bindings" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.things.count) {
        status_label.text = @"";
        return self.things.count;
    }else
    {
        status_label.text = @"No things found";
        return 0;
    }
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    ThingsCell *cell = (ThingsCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    if (!cell) {
        cell = [[ThingsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    Things *thing = [self.things objectAtIndex:indexPath.row];
    
    cell.name.text = thing.name;
    cell.status.text = thing.status_info;
    cell.type.text = thing.item_type;
    cell.logo_label.text = [[thing.item_type substringToIndex:1] uppercaseString];
    cell.status.layer.cornerRadius = 3.0f;
    cell.status.layer.masksToBounds = YES;
    
    cell.delegate = self;
    
    cell.logo_label.layer.cornerRadius = 20.0f;
    cell.logo_label.layer.masksToBounds = YES;
    cell.logo_label.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.logo_label.layer.borderWidth = 1.0f;
    
    cell.name.backgroundColor = cell.type.backgroundColor = [UIColor clearColor];
    
    cell.backgroundColor = [UIColor clearColor];
    
    
    cell.rightButtons =  @[[MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor flatRedColorDark]],[MGSwipeButton buttonWithTitle:@"Edit" backgroundColor:[UIColor flatBrownColorDark]]];
    
    cell.rightSwipeSettings.transition = MGSwipeTransitionBorder;
    
    return cell;
}

-(BOOL)swipeTableCell:(MGSwipeTableCell *)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion
{
    NSLog(@"%d",index);
    return YES;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
