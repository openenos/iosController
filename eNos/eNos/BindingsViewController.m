//
//  BindingsViewController.m
//  eNos
//
//  Created by AMZUR Technologies on 04/12/15.
//  Copyright © 2015 AMZUR Technologies. All rights reserved.
//

#import "BindingsViewController.h"
#import "eNosAPI.h"
#import "defines.h"
#import "Bindings.h"
@interface BindingsViewController ()
{
    NSMutableArray *bindings_list;
    UILabel *status_label;
}
@end

@implementation BindingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.jpg"]];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    status_label = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height-100)/2, self.view.frame.size.width, 100)];
    status_label.textColor = [UIColor lightGrayColor];
    status_label.textAlignment = NSTextAlignmentCenter;
    status_label.font = [UIFont fontWithName:AVENIR_MEDIUM size:16];
    status_label.backgroundColor = [UIColor clearColor];
    
    self.title = @"Select";
    
    [self.tableView.backgroundView addSubview:status_label];
    
    bindings_list = [NSMutableArray new];
    
    status_label.text = @"Loading...";
    
    [self.tableView reloadData];
    
    [[eNosAPI sharedAPI] getBindings:nil block:^(id responseObject, NSError *error) {
        
        if (error) {
            
            NSLog(@"%@",error.localizedDescription);
        }else
        {
            NSDictionary *bindings = [responseObject objectAtIndex:0];
            
            NSArray *thingtypes = [bindings objectForKey:@"thingTypes"];
            
            for (NSDictionary *thing in thingtypes) {
                
                Bindings *binding = [[Bindings alloc] init];
                
                [binding setName:[thing objectForKey:@"label"]];
                [binding setBinding_description:[thing objectForKey:@"description"]];
                
                [bindings_list addObject:binding];
            }
            
            [self.tableView reloadData];
            
            
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (bindings_list.count) {
        
        status_label.text = @"";
        return bindings_list.count;
        
    }else
    {
        status_label.text = @"No Bindings found";
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    Bindings *binding = [bindings_list objectAtIndex:indexPath.row];
    
    cell.textLabel.text = binding.name;
    cell.detailTextLabel.text = binding.binding_description;
    
    return cell;
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
