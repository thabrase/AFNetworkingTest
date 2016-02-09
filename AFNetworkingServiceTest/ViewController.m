//
//  ViewController.m
//  AFNetworkingServiceTest
//
//  Created by Vivid6 on 08/02/16.
//  Copyright © 2016 Vivid6. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "APIClientCall.h"
#import "MBProgressHUD.h"
#import "TSMessage.h"
#import "TSMessageView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LocationUpdate:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText =@"Loading...";
    APIClientCall * sharedClient = [APIClientCall sharedClient];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setObject:@"55" forKey:@"UserId"];
    [params setObject:@"13.025" forKey:@"latitude"];
    [params setObject:@"80.256" forKey:@"longitude"];
    [sharedClient getLocationUpdateWithParams:params success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"Search Response:%@",response);
        [hud hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [sharedClient.manager.requestSerializer clearAuthorizationHeader];
        NSLog(@"error:%@",error.description);
        [hud hide:YES];
    }];
}
@end
