//
//  APIClientCall.m
//  AFNetworkingServiceTest
//
//  Created by Vivid6 on 08/02/16.
//  Copyright © 2016 Vivid6. All rights reserved.
//

#import "APIClientCall.h"
#import "AFNetworking.h"
#import "TSMessage.h"
#import "TSMessageView.h"

typedef void(^HKUPSuccessBlock)(AFHTTPRequestOperation* operation, id response);
typedef void(^HKUPFailureBlock)(AFHTTPRequestOperation* operation, NSError *error);
@implementation APIClientCall
static NSString * const kHookUpAPIClientBaseURLString = @"Enter Base URL here";
//
+ (APIClientCall *)sharedClient {
    static APIClientCall *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
        _sharedClient = [[APIClientCall alloc] initWithBaseURL:[NSURL URLWithString:kHookUpAPIClientBaseURLString]];
    });
    return _sharedClient;
}
- (BOOL)connected {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}
- (id)initWithBaseURL:(NSURL *)url {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.responseSerializer.acceptableContentTypes = [self.manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    self.serializationQueue = dispatch_queue_create("Serialization Queue", DISPATCH_QUEUE_CONCURRENT);
    return self;
    
}
- (AFHTTPRequestOperation*) getRequestSearchWithParams:(NSDictionary*)params success:(HKUPSuccessBlock)success failure:(HKUPFailureBlock)failure {
    return [self operationForPostPath:@"GetTaxInfoDetailsByUserID?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self handleJSONArrayResponse:responseObject
                            operation:operation
                              success:success
                              failure:failure];        
    } failure:failure];
}
- (AFHTTPRequestOperation*) getLocationUpdateWithParams:(NSDictionary*)params success:(HKUPSuccessBlock)success failure:(HKUPFailureBlock)failure {
    return [self operationForPostPath:@"InsertUserLocation?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self handleJSONArrayResponse:responseObject
                            operation:operation
                              success:success
                              failure:failure];
        
    } failure:failure];
}
- (AFHTTPRequestOperation*) operationForPostPath:(NSString*)path
                                      parameters:(NSDictionary*)params
                                         success:(HKUPSuccessBlock)success
                                         failure:(HKUPFailureBlock)failure {
    if (![self connected]) {
        [TSMessage showNotificationWithTitle:NSLocalizedString(@"No Internet Connection", nil)subtitle:NSLocalizedString(@"Look out! Something is happening there!", nil) type:TSMessageNotificationTypeWarning];
    }
    //Get Method
    AFHTTPRequestOperation *oper = [self.manager GET:path parameters:params success:success failure:failure];
    //POST Method
//    AFHTTPRequestOperation *operation = [self.manager POST:path parameters:params success:success failure:failure];
    return oper;
    
}

-(void) handleJSONArrayResponse:(NSDictionary*)response
                      operation:(AFHTTPRequestOperation*)operation
                        success:(HKUPSuccessBlock)success
                        failure:(HKUPFailureBlock)failure
{
    
    NSArray *data = [response mutableCopy];
    
    dispatch_after(DISPATCH_TIME_NOW, self.serializationQueue, ^{
        
        NSError *error = nil;
        NSArray *models = data;
        dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), ^{
            if (error) {
                failure(operation, error);
            } else {
                success(operation, models);
            }
        });
        
    });
    
}
@end
