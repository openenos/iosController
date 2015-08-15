//
//  eNosAPI.h
//  openHAB
//
//  Created by AMZUR Technologies on 15/08/15.
//  Copyright (c) 2015 Victor Belov. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface eNosAPI : AFHTTPRequestOperationManager
+(eNosAPI *)sharedAPI;
-(id)initWithBaseURL:(NSURL *)url;

-(void)getSitemaps:(NSDictionary *)params block:(void(^)(id responseObject, NSError *error))block;
-(void)getGroups:(NSString *)url block:(void(^)(id responseObject, NSError *error))block;

@end
