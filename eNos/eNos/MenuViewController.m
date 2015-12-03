//
//  MenuViewController.m
//  eNos
//
//  Created by AMZUR Technologies on 30/11/15.
//  Copyright © 2015 AMZUR Technologies. All rights reserved.
//

#import "MenuViewController.h"
#import "SlideNavigationController.h"
#import "SlideNavigationContorllerAnimatorFade.h"
#import "SlideNavigationContorllerAnimatorSlide.h"
#import "SlideNavigationContorllerAnimatorScale.h"
#import "SlideNavigationContorllerAnimatorScaleAndFade.h"
#import "SlideNavigationContorllerAnimatorSlideAndFade.h"
#import "HomeViewController.h"
#import "defines.h"
@interface MenuViewController ()
@property NSMutableArray *menu_items;
@property NSMutableArray *control_items;
@property NSMutableArray *pageurls;
@end

@implementation MenuViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.slideOutAnimationEnabled = YES;
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatemenuitems:) name:@"menu_update" object:nil];
    
    return [super initWithCoder:aDecoder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.menu_items = [NSMutableArray arrayWithObjects:@"Things",@"Inbox",@"Items",nil];
    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftMenu.jpg"]];
//    self.tableView.backgroundView = imageView;
    
    self.tableView.backgroundColor = [UIColor colorWithAverageColorFromImage:[UIImage imageNamed:@"bg.jpg"]];
    
    self.tableView.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleRadial withFrame:self.tableView.bounds andColors:@[[UIColor colorFromImage:[UIImage imageNamed:@"bg.jpg"] atPoint:CGPointMake(90, 90)],[UIColor flatBlackColor],[UIColor colorWithAverageColorFromImage:[UIImage imageNamed:@"bg.jpg"]]]];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)updatemenuitems:(NSNotification *)sender
{
    NSDictionary *dict = sender.object;
    
    self.control_items = [NSMutableArray arrayWithArray:[dict objectForKey:@"groups"]];
    self.pageurls = [NSMutableArray arrayWithArray:[dict objectForKey:@"linkedpages"]];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else
    {
        return 40;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"";
    }else if (section == 1)
    {
        return @"Control";
    }else
    {
        return @"Configuration";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 1) {
        return self.control_items.count;
    }else if (section == 2)
    {
        return self.menu_items.count;
    }else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    if (indexPath.section == 0) {
        
        cell.textLabel.text = @"          eNOS";
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
        
    }else if(indexPath.section == 1){
        
        cell.textLabel.text = [self.control_items objectAtIndex:indexPath.row];
        
        cell.textLabel.font = [UIFont fontWithName:AVENIR_MEDIUM size:20];
        
        cell.textLabel.textColor = [UIColor whiteColor];
        
        cell.imageView.image = [UIImage imageNamed:@"item.png"];
        
    }else if(indexPath.section == 2)
    {
        cell.textLabel.text = [self.menu_items objectAtIndex:indexPath.row];
        
        cell.textLabel.font = [UIFont fontWithName:AVENIR_MEDIUM size:20];
        
        cell.textLabel.textColor = [UIColor whiteColor];
        
        cell.imageView.image = [UIImage imageNamed:@"item.png"];
    }
    
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
       
        return 120;
        
    }else
    {
        return 50;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }else if(indexPath.section == 2)
    {
        UIViewController *vc;
        
        if(indexPath.row == 1)
        {
            vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"inbox"];
            
        }else if (indexPath.row == 0)
        {
            vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"things"];
        }
        else
        {
            vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"home"];
        }
        
        
        [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                                 withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                         andCompletion:nil];
    }else
    {
        HomeViewController *vc;
        
        vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"homeview"];
        
        vc.pageurl = [self.pageurls objectAtIndex:indexPath.row];
        vc.groupname = [self.control_items objectAtIndex:indexPath.row];
    
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:[NSDictionary dictionaryWithObjectsAndKeys:[self.pageurls objectAtIndex:indexPath.row],@"page",[self.control_items objectAtIndex:indexPath.row],@"group",nil]];
        
        [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                                 withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                         andCompletion:nil];
        
       

    }
    
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
