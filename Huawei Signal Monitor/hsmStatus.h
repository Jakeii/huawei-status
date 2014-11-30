//
//  hsmStatus.h
//  HuaweiSignalMonitor
//
//  Created by Jake Lee Kennedy on 02/09/2014.
//  Copyright (c) 2014 Jake Lee Kennedy. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HSMStatus : NSObject

- (void)getUpdatedStatusWithCompletionHandler:(void (^)(NSDictionary *statuses, NSError *error))completionHandler;


@end