//
//  eNosAPI.h
//  openHAB
//
//  Created by AMZUR Technologies on 15/08/15.
//  Copyright (c) 2015 Victor Belov. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "defines.h"
@interface eNosAPI : AFHTTPRequestOperationManager
+(eNosAPI *)sharedAPI;
-(id)initWithBaseURL:(NSURL *)url;

-(void)getSitemaps:(NSDictionary *)params block:(void(^)(id responseObject, NSError *error))block;
-(void)getGroups:(NSString *)url block:(void(^)(id responseObject, NSError *error))block;
-(void)getGroupItems:(NSString *)url block:(void(^)(id responseObject, NSError *error))block;
//Getting new things in Inbox
-(void)getNewDevice:(NSDictionary *)param block:(void(^)(id responseObject, NSError *error))block;
//Approve the thing in Inbox
-(void)ApproveThings:(NSString *)param block:(void(^)(id responseObject,NSError *error))block;
//Adding the things to Groups form Inbox
-(void)ThingsAddedToGroup:(NSString *)thingId groupNames:(NSArray *)param block:(void (^)(id responseObject, NSError *error))block;
//Geting the groups For inbox items
-(void)getGroupsInbox:(NSString *)url block:(void(^)(id responseObject,NSError *error))block;
//Deleting the thing from inbox
-(void)deleteThingFromInbox:(NSString *)thing block:(void(^)(id responseObject,NSError *error))block;
//Ignoring the things from Inbox
-(void)ignoringThingsfromInbox:(NSString *)thingId block:(void(^)(id responseObject,NSError *error))block;
//geting all the things
-(void)getAllThings:(NSString *)url block:(void(^)(id responseObject,NSError *error))block;
@end
