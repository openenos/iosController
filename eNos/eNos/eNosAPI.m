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

@end
