//
//  hsmStatus.m
//  HuaweiSignalMonitor
//
//  Created by Jake Lee Kennedy on 02/09/2014.
//  Copyright (c) 2014 Jake Lee Kennedy. All rights reserved.
//

#import "hsmStatus.h"
#import "GDataXMLNode.h"

@implementation HSMStatus

//- (id)init
//{
//    return self;
//}

// <?xml version:"1.0" encoding="UTF-8"?><request><Username>admin</Username><Password>YWRtaW4=</Password></request>
// /api/user/login
// Content-Type:application/x-www-form-urlencoded

- (void)getUpdatedStatusWithCompletionHandler:(void (^)(NSDictionary *, NSError *))completionHandler
{
    NSURLComponents *URLComponents = [NSURLComponents componentsWithString:@"http://192.168.1.1"];
    URLComponents.path = @"/api/monitoring/status";
    
    NSURL *URL = [URLComponents URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
      if (data) {
          GDataXMLDocument *xmlRoot = [[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
          NSArray *doc = [xmlRoot nodesForXPath:@"//response" error:nil];
          
          if (doc == nil) { completionHandler(nil, error); }
          
          NSMutableDictionary *statuses = [[NSMutableDictionary alloc] init];
          
          GDataXMLElement *responseElement = [doc objectAtIndex:0];
          NSArray *statusElements = [responseElement children];
          for (GDataXMLElement *statusElement in statusElements) {
              [statuses setValue:statusElement.stringValue forKey:[statusElement name]];
              //NSLog(@"%@", [[NSArray arrayWithObjects:[statusElement name], statusElement.stringValue, nil ] componentsJoinedByString:@": "]);
          }
          
          completionHandler(statuses, error);
      } else {
          completionHandler(nil, error);
      }
  }];
    
    [task resume];


}

@end