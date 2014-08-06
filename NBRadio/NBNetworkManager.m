//
//  NBNetworkManager.m
//  NBRadio
//
//  Created by Kanybek Momukeev on 06/08/14.
//  Copyright (c) 2014 Kanybek Momukeev. All rights reserved.
//

#import "NBNetworkManager.h"
#import "AFHTTPRequestOperationManager.h"

@implementation NBNetworkManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static NBNetworkManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[NBNetworkManager alloc] init];
    });
    return sharedInstance;
}

- (void)allRadioStationsWithCompletion:(CompletionBlock)completion
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://namba.kg/api/?service=home&action=radioHome" parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSArray *stations = [responseObject objectForKey:@"stations"];
        completion(stations, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completion(nil, error);
    }];
}

@end
