//
//  APIClientCall.h
//  AFNetworkingServiceTest
//
//  Created by Vivid6 on 08/02/16.
//  Copyright © 2016 Vivid6. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
typedef void(^HKUPSuccessBlock)(AFHTTPRequestOperation* operation, id response);
typedef void(^HKUPFailureBlock)(AFHTTPRequestOperation* operation, NSError *error);

@interface APIClientCall : NSObject
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic, strong) dispatch_queue_t serializationQueue;
+ (APIClientCall *)sharedClient;
- (AFHTTPRequestOperation*) getRequestSearchWithParams:(NSDictionary*)params success:(HKUPSuccessBlock)success failure:(HKUPFailureBlock)failure;
- (AFHTTPRequestOperation*) getLocationUpdateWithParams:(NSDictionary*)params success:(HKUPSuccessBlock)success failure:(HKUPFailureBlock)failure;
@end
