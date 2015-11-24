//
//  eNosAPI.m
//  openHAB
//
//  Created by AMZUR Technologies on 15/08/15.
//  Copyright (c) 2015 Victor Belov. All rights reserved.
//

#import "eNosAPI.h"
@implementation eNosAPI
+(eNosAPI *)sharedAPI
{
    static eNosAPI *_shareeTekiapi = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _shareeTekiapi = [[self alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    });
    
    return _shareeTekiapi;
}

-(id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer =  [AFJSONRequestSerializer serializer];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.reachabilityManager startMonitoring];
    }
    
    return self;
}

-(void)getGroups:(NSString *)url block:(void (^)(id, NSError *))block
{
    [self GET:[url stringByReplacingOccurrencesOfString:BASE_URL withString:@""] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block([NSDictionary new],error);
    }];
}

-(void)getSitemaps:(NSDictionary *)params block:(void (^)(id, NSError *))block
{
    [self GET:@"/rest/sitemaps" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block([NSDictionary new],error);
    }];
}

-(void)getGroupItems:(NSString *)url block:(void (^)(id, NSError *))block
{
    [self GET:[url stringByReplacingOccurrencesOfString:BASE_URL withString:@""] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block([NSDictionary new],error);
    }];
}
//Getting new things in Inbox
-(void)getNewDevice:(NSDictionary *)param block:(void (^)(id, NSError *))block
{
    [self GET:@"/rest/inbox" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block([NSDictionary new],error);
    }];
}
//Approve the thing in Inbox
-(void)ApproveThings:(NSString *)param block:(void(^)(id,NSError *))block
{
    [self POST:[NSString stringWithFormat:@"/rest/inbox/%@/approve",param] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block([NSDictionary new],error);
    }];
}
//Adding the things to Groups form Inbox
-(void)ThingsAddedToGroup:(NSString *)thingId groupNames:(NSArray *)param block:(void (^)(id, NSError *))block
{
[self PUT:[NSString stringWithFormat:@"/rest/setup/things/%@/groups", thingId] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
    block(responseObject,nil);
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    block([NSDictionary new],error);
}];
}
//Geting the groups For inbox items
-(void)getGroupsInbox:(NSString *)url block:(void (^)(id, NSError *))block
{
[self GET:@"/rest/setup/groups" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    block(responseObject,nil);
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    block([NSDictionary new],error);
}];

}
//Deleting the thing from inbox
-(void)deleteThingFromInbox:(NSString *)thing block:(void (^)(id, NSError *))block
{
    [self DELETE:[NSString stringWithFormat:@"/rest/index/%@",thing] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block([NSDictionary new],error);
    }];


//    [self POST:@"" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        block(responseObject,nil);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        block([NSDictionary new],error);
//    }];

}
//Ignoring Things from Inbox
-(void)ignoringThingsfromInbox:(NSString *)thingId block:(void (^)(id, NSError *))block
{

[self POST:[NSString stringWithFormat:@"/rest/inbox/%@/ignore",thingId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    block(responseObject,nil);
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    block([NSDictionary new],error);
}];
}

//geting all things
-(void)getAllThings:(NSString *)url block:(void (^)(id, NSError *))block
{

[self GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    block(responseObject,nil);
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    block([NSDictionary new],error);
}];
}
@end
