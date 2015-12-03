//
//  InboxViewController.m
//  eNos
//
//  Created by Tirupathi on 20/08/15.
//  Copyright (c) 2015 AMZUR Technologies. All rights reserved.
//

#import "InboxViewController.h"
#import "InBoxCell.h"
#import "InboxModel.h"
#import "defines.h"
#import "eNosAPI.h"
#import "CustomCell.h"
#import "DXPopover.h"
#import "defines.h"
#import "SlideNavigationController.h"
@interface InboxViewController ()
{
    UIActivityIndicatorView *activity;
    UILabel *status_label;
}
@property NSMutableArray *inbox_items;
@end

@implementation InboxViewController
{
    DXPopover *popover;
    NSString *thingId;
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    
    self.title = @"Inbox";
    
    self.inbox_items = [NSMutableArray new];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.jpg"]];
    status_label = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height-100)/2, self.view.frame.size.width, 100)];
    status_label.textColor = [UIColor lightGrayColor];
    status_label.textAlignment = NSTextAlignmentCenter;
    status_label.font = [UIFont fontWithName:AVENIR_MEDIUM size:16];
    status_label.backgroundColor = [UIColor clearColor];
    status_label.text = @"Loading...";
    
    [self.tableView.backgroundView addSubview:status_label];
    
    //Making the tablefooterview as Zero;
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    
    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    self.tableview.tableHeaderView = activity;
    
    
    [activity startAnimating];
    activity.hidesWhenStopped = YES;
    
    [[eNosAPI sharedAPI] getGroupsInbox:nil block:^(id responseObject, NSError *error) {
        
        [activity stopAnimating];
        
        if (error) {
            
        }else if ([responseObject isKindOfClass:[NSArray class]])
        {
            
            
        }else
        {
            
        }
    }];
    
    
}
//To Close the InboxViewcontroller
- (IBAction)closeInboxView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.inbox_items.count) {
        status_label.text = @"";
        return self.inbox_items.count;
    }else
    {
        status_label.text = @"Inbox is empty";
        return 0;
    }
    
    return 0;
    
}

// Configure the cell...
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
//    if (tableView==self.tableview) {
//        // Configure the cell...
//        CustomCell *customcell=(CustomCell *)[self.tableView dequeueReusableCellWithIdentifier:@"Customcell"];
//        if (!customcell) {
//            NSArray *nibfiel=[[NSBundle mainBundle] loadNibNamed:@"Customcell" owner:self options:nil];
//            customcell=[nibfiel objectAtIndex:0];
//        }
//        //Assign InboxModel object at cell
//        InboxModel *groupmodeldata=[groupsList objectAtIndex:indexPath.row];
//        
//        //set backgroundImage to check button
//        [customcell.checkButton setBackgroundImage:[UIImage imageNamed:@"uncheck_icon.png"] forState:UIControlStateNormal];
//        //adding action to the CheckButton
//
//        [customcell.checkButton addTarget:self action:@selector(handleCheckMark:) forControlEvents:UIControlEventTouchUpInside];
//        customcell.labelName.text=[groupmodeldata groupname];
//        
//        customcell.backgroundColor = [UIColor clearColor];
//        
//        //return custom cell
//        return customcell;
//        
//    }else{
        // Configure the cell...
        InBoxCell *cell=(InBoxCell *)[self.tableView dequeueReusableCellWithIdentifier:@"inboxcell"];
        if (!cell) {
            cell=[[InBoxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"inboxcell"];
        }
        //adding CornerRadious to approve,delete and ingnore buttons
        cell.approveButton.layer.cornerRadius = cell.deleteButton.layer.cornerRadius = cell.ignoreButton.layer.cornerRadius=5.0;
        //adding BorderColor to approve,delete and ingnore buttons
        cell.approveButton.layer.borderColor=cell.deleteButton.layer.borderColor=cell.ignoreButton.layer.borderColor=[UIColor whiteColor].CGColor;
        //adding borderWidth to approve,delete and ingnore buttons
        cell.approveButton.layer.borderWidth=cell.deleteButton.layer.borderWidth=cell.ignoreButton.layer.borderWidth=1;
        //adding showsTouchWhenHighlighted for approve ,delete and ignore buttons
        cell.approveButton.showsTouchWhenHighlighted = cell.deleteButton.showsTouchWhenHighlighted = cell.ignoreButton.showsTouchWhenHighlighted=YES;
        //adding action to Approve button
        [cell.approveButton addTarget:self action:@selector(handleApproveThing:) forControlEvents:UIControlEventTouchUpInside];
        //adding action to Delete button
        [cell.deleteButton addTarget:self action:@selector(handleDeleteThing:) forControlEvents:UIControlEventTouchUpInside];
        //adding action to Ignore button
        [cell.ignoreButton addTarget:self action:@selector(handleIgnoreThing:) forControlEvents:UIControlEventTouchUpInside];
        
        //assign the data to inboxModel object
//        InboxModel *modeldata=[self.inboxInfo objectAtIndex:indexPath.row];
    
//        //Assigning thing name to thingname label
//        cell.thinkName.text=[modeldata thingName];
//        //Assigning thing id to thigId label.
//        cell.thingId.text=[modeldata thingId];
//        
//        cell.backgroundColor = [UIColor clearColor];
    
        //return InboxCell
        return cell;

//    }
//    return nil;
}

//Adding footerview for tableview
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView==self.tableview) {
        //adding view on footer view
        UIView *footerview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
        //Defining the addingThing button
        UIButton *addThingButton=[[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-140, 5, 90, 30)];
        [addThingButton setTitle:@"Add Thing" forState:UIControlStateNormal];
        //defining the Cancel button
        UIButton *cancelButton=[[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-240, 5, 80, 30)];
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        //set backgroun color to addthing button
        [addThingButton setBackgroundColor:[UIColor  colorWithRed:109.0/255.0 green:163.0/255.0 blue:225.0/255.0 alpha:1.0]];
        //set backgroun color to Cancel button
        [cancelButton setBackgroundColor:[UIColor redColor]];
        //set cornerradious to addingthing button and CancelButton
        cancelButton.layer.cornerRadius=addThingButton.layer.cornerRadius=5;
        //set border Color to addingthing button and CancelButton
        cancelButton.layer.borderColor=addThingButton.layer.borderColor=[UIColor whiteColor].CGColor;
        //set borderWidth to addingthing button and CancelButton
        cancelButton.layer.borderWidth=addThingButton.layer.borderWidth=1;
        //Add Action to the Cancel Button
        [cancelButton addTarget:self action:@selector(handleCancelAddingThing) forControlEvents:UIControlEventTouchUpInside];
        //Adding action to AddingThings button
        [addThingButton addTarget:self action:@selector(handleAddingThing:) forControlEvents:UIControlEventTouchUpInside];
        //add addthingButton as subview to footerview
        [footerview addSubview:addThingButton];
        //add CancelButton as subview to footerview
        [footerview addSubview:cancelButton];
        return footerview;
    }
    else
        return [[UIView alloc] initWithFrame:CGRectZero];

}
//set height of footerview in section
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView==self.tableview) {
        return 70;
    }else
        return 0;
}
//Dismiss the popover
-(void)handleCancelAddingThing
{
    [popover dismiss];
}
////adding things to group
-(void)handleAddingThing:(UIButton *)sender
{
    // call Approve thing method from eNosAPI class
    
//    [[eNosAPI sharedAPI] ApproveThings:thingId block:^(id responseObject, NSError *error) {
//        
//        if (error) {
//            
//            NSLog(@"%@",error.localizedDescription);
//            
//        }else{
    
          //  NSMutableDictionary *param=[NSMutableDictionary new];
           // param[@"List"]=groupIds_list;
//            //After Approval call Things AddToGroup
//            [[eNosAPI sharedAPI] ThingsAddedToGroup:thingId groupNames:groupIds_list block:^(id responseObject, NSError *error) {
//                if (error) {
//                    
//                    NSLog(@"%@",error.localizedDescription);
//                }else
//                {
//                    
//                    [popover dismiss];
//                    NSLog(@"%@",groupIds_list);
//                    groupIds_list=[NSMutableArray new];
//                    NSLog(@"Thing_success");
//                
//                }
//            }];
//
//            NSLog(@"Approve_success");
//            
//        }
//        
//    }];

}
//Handele Chaeck Box button on Custom cell
-(void)handleCheckMark:(UIButton *)sender
{

//   //to get custom cell
//    CustomCell *customcelldata=(CustomCell *)sender.superview.superview;
//    //get indexPath for cell
//    NSIndexPath *indexCell=[self.tableview indexPathForCell:customcelldata];
//    //assign data to Inboxmodel at indexpath
//    InboxModel *inboxgroupdata=[groupsList objectAtIndex:indexCell.row];
//    //change the Backgroud image of checkBox button based on condiation
//    if ([[customcelldata.checkButton backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"uncheck_icon.png"]]) {
//        [customcelldata.checkButton setBackgroundImage:[UIImage imageNamed:@"check_icon.png"] forState:UIControlStateNormal];
//        [groupIds_list addObject:[inboxgroupdata groupID]];
//        
//    }else{
//    
//    [customcelldata.checkButton setBackgroundImage:[UIImage imageNamed:@"uncheck_icon.png"] forState:UIControlStateNormal];
//        [groupIds_list removeObject:[inboxgroupdata groupID]];
//    }

}
//get the groups for inbox things
-(void)getGroups
{

//[[eNosAPI sharedAPI] getGroupsInbox:nil block:^(id responseObject, NSError *error) {
//   
//    if (error) {
//        
//        
//        
//    }else{
//        if ([responseObject isKindOfClass:[NSArray class]]) {
//            
//            //run for loop till object in responseObject
//            for (NSDictionary *dicts in responseObject) {
//                //initialize InboxModel
//                InboxModel *groupIds=[[InboxModel alloc] init];
//                //set the data to model object
//                [groupIds setGroupID:[dicts objectForKey:@"name"]];
//                [groupIds setGroupname:[dicts objectForKey:@"label"]];
//                //add model object to groups List array
//                [groupsList addObject:groupIds];
//                
//            }
//        } else {
//            
//        }
//    
//    
//    }
//}];

}

//handleing approving things at a cell
-(void)handleApproveThing:(UIButton *)sender
{
//cell at approve button
//    InBoxCell *inboxcell=(InBoxCell *)sender.superview.superview;
//    //indexpath for that cell
//    NSIndexPath *index=[self.tableView indexPathForCell:inboxcell];
//    //model object at that indexpath
//    InboxModel *model=[self.inboxInfo objectAtIndex:index.row];
//    
//    thingId=[model thingId];
//    //initialize thableview
//    self.tableview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
//    //assiging delegate
//    self.tableview.delegate=self;
//    //assiging dataSource
//    self.tableview.dataSource=self;
//    //adding sepratorStyle of table view as none.
//    self.tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
//    [self.tableview reloadData];
//    //Initialize the Popover
//    popover=[[DXPopover alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
//    //present the popover with tableview data.
//    [popover showAtPoint:self.view.center popoverPostion:0 withContentView:self.tableview inView:self.view];
    
}

//handling Delete things from inbox
-(void)handleDeleteThing:(UIButton *)sender
{

}

//handling Ignore things from inbox
-(void)handleIgnoreThing:(UIButton *)sender
{

    
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
