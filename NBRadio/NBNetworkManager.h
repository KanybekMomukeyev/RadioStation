//
//  NBNetworkManager.h
//  NBRadio
//
//  Created by Kanybek Momukeev on 06/08/14.
//  Copyright (c) 2014 Kanybek Momukeev. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CompletionBlock)(id, NSError *);
typedef void (^ComplexBlock)(id, id);
typedef void (^TripleComplexBlock)(id, id, id);
typedef void (^SimpleBlock)(void);
typedef void (^InfoBlock)(id);
typedef void (^ConfirmationBlock)(BOOL);
typedef BOOL (^BoolBlock)(id);
typedef void (^DownloadProgressBlock)(NSUInteger bytesRead, long long totalBytes, long long totalBytesExp);

@interface NBNetworkManager : NSObject
+ (instancetype)sharedInstance;
- (void)allRadioStationsWithCompletion:(CompletionBlock)completion;
@end
