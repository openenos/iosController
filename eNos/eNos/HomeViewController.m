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
@interface HomeViewController ()
{
    NSMutableArray *items_list;
}
@end

@implementation HomeViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
    
    items_list = [NSMutableArray new];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    
    
    [[eNosAPI sharedAPI] getGroupItems:self.pageurl block:^(id responseObject, NSError *error) {
        
        if (!error) {
            
            NSArray *memebers = [responseObject objectForKey:@"members"];
            
            for (NSDictionary *memeber in memebers) {
                
                NSArray *memebers = [memeber objectForKey:@"members"];
                
                GroupItems *groupitem = [[GroupItems alloc] init];
                
                NSDictionary *memberdict = [memebers objectAtIndex:0];
                
                [groupitem setType:[memberdict objectForKey:@"type"]];
                [groupitem setLabelValue:[memberdict objectForKey:@"label"]];
                [groupitem setState:[memberdict objectForKey:@"state"]];
                [groupitem setLabelText:[memeber objectForKey:@"label"]];
                
                if ([memberdict objectForKey:@"stateDescription"] != (id)[NSNull null]) {
                    
                    [groupitem setPattern:[[memberdict objectForKey:@"stateDescription"] objectForKey:@"pattern"]];
                }
                
                
                [items_list addObject:groupitem];
            }
            
            NSLog(@"%d",items_list.count);
            [self.collectionView reloadData];
            
        }else
        {
            NSLog(@"%@",error);
        }
    }];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return items_list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    GroupItems *widget = [items_list objectAtIndex:indexPath.row];
    
    NSString *cellIdentifier = @"GenericWidgetCell";
    
    if ([widget.type isEqualToString:@"SwitchItem"]) {
//        if ([widget.mappings count] > 0) {
//            cellIdentifier = @"SegmentedWidgetCell";
//        } else if ([widget.item.type isEqualToString:@"RollershutterItem"]) {
//            cellIdentifier = @"RollershutterWidgetCell";
//        } else {
            cellIdentifier = @"SwitchWidgetCell";
//        }
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
    
    GenericUITableViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
//    // No icon is needed for image, video, frame and web widgets
//    if (widget.icon != nil && !([cellIdentifier isEqualToString:@"ChartWidgetCell"] || [cellIdentifier isEqualToString:@"ImageWidgetCell"] || [cellIdentifier isEqualToString:@"VideoWidgetCell"] || [cellIdentifier isEqualToString:@"FrameWidgetCell"] || [cellIdentifier isEqualToString:@"WebWidgetCell"])) {
//        NSString *iconUrlString = [NSString stringWithFormat:@"%@/images/%@.png", self.openHABRootUrl, widget.icon];
//        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:iconUrlString] placeholderImage:[UIImage imageNamed:@"blankicon.png"] options:0];
//    }
//    if ([cellIdentifier isEqualToString:@"ColorPickerWidgetCell"]) {
//        ((ColorPickerUITableViewCell*)cell).delegate = self;
//    }
//    if ([cellIdentifier isEqualToString:@"ChartWidgetCell"]) {
//        NSLog(@"Setting cell base url to %@", self.openHABRootUrl);
//        ((ChartUITableViewCell*)cell).baseUrl = self.openHABRootUrl;
//    }
//    if ([cellIdentifier isEqualToString:@"ChartWidgetCell"] || [cellIdentifier isEqualToString:@"ImageWidgetCell"]) {
//        [(ImageUITableViewCell *)cell setDelegate:self];
//    }
    [cell loadWidget:widget];
    [cell displayWidget];
    // Check if this is not the last row in the widgets list
//    if (indexPath.row < [currentPage.widgets count] - 1) {
//        OpenHABWidget *nextWidget = [currentPage.widgets objectAtIndex:indexPath.row + 1];
//        if ([nextWidget.type isEqual:@"Frame"] || [nextWidget.type isEqual:@"Image"] || [nextWidget.type isEqual:@"Video"] || [nextWidget.type isEqual:@"Webview"] || [nextWidget.type isEqual:@"Chart"]) {
//            cell.separatorInset = UIEdgeInsetsZero;
//        } else if (![widget.type isEqualToString:@"Frame"]) {
//            cell.separatorInset = UIEdgeInsetsMake(0, 60, 0, 0);
//        }
//    }

    
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.cornerRadius = 4.0f;
//    cell.layer.borderColor = [UIColor grayColor].CGColor;
//    cell.layer.borderWidth = 1.0f;
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return UIEdgeInsetsMake(20, 20, 20, 20);
    }else
    {
        return UIEdgeInsetsMake(20, 0, 20, 0);
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
