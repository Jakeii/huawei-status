//
//  hsmAppDelegate.m
//  Huawei Signal Monitor
//
//  Created by Jake Lee Kennedy on 02/09/2014.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "hsmAppDelegate.h"
#import "hsmStatus.h"
#import "GDataXMLNode.h"

@interface hsmAppDelegate ()

@property (strong, nonatomic) HSMStatus *hsmStatus;


@end

@implementation hsmAppDelegate

//@synthesize window;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"HSMRefreshInterval": @5}];
    
    //[connectionTypes addEntriesFromDictionary:connectionTypes1];
    
    [self setupMenu];
    [self updateSignalStrength:nil];
    
    NSTimeInterval ti = [[NSUserDefaults standardUserDefaults] doubleForKey:@"HSMRefreshInterval"];
    [NSTimer scheduledTimerWithTimeInterval:ti target:self selector:@selector(updateSignalStrength:) userInfo:nil repeats:YES];
}

-(void)awakeFromNib{
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
    [statusItem setMenu:statusMenu];
    [statusItem setTitle:@""];
    [statusItem setImage:[NSImage imageNamed:@"Silver_0_Bars@2x"]];
    [statusItem setHighlightMode:YES];
}

- (void)setupMenu
{
    [openPageMenuItem setAction:@selector(openPage:)];
    [rebootMenuItem setAction:@selector(rebootModem:)];
    [quitMenuItem setAction:@selector(terminate:)];
}

- (void)openPage:(id)sender
{
    NSURL *URL = [NSURL URLWithString:@"http://192.168.1.1"];
    [[NSWorkspace sharedWorkspace] openURL:URL];
}

- (void)rebootModem:(id)sender
{
    // /api/device/control <?xml version:"1.0" encoding="UTF-8"?><request><Control>1</Control></request>
    
    NSURLComponents *LoginURLComponents = [NSURLComponents componentsWithString:@"http://192.168.1.1/api/user/login"];
//    LoginURLComponents.path = @"/api/user/login";
    
    NSMutableURLRequest *LoginRequest = [NSMutableURLRequest requestWithURL:[LoginURLComponents URL]];
    
    [LoginRequest setHTTPMethod:@"POST"];
    
    [LoginRequest setHTTPBody:[@"<?xml version:\"1.0\" encoding=\"UTF-8\"?><request><Username>admin</Username><Password>YWRtaW4=</Password></request>" dataUsingEncoding:NSUTF8StringEncoding]];
    [LoginRequest setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *loginTask = [[NSURLSession sharedSession] dataTaskWithRequest:LoginRequest completionHandler:^(NSData *loginData, NSURLResponse *loginResponse, NSError *loginError) {
        if (loginData) {
            // NSHTTPURLResponse *loginHTTPresponse = (NSHTTPURLResponse *)loginResponse;
            
            NSURLComponents *rebootURLComponents = [NSURLComponents componentsWithString:@"http://192.168.1.1/api/device/control"];
            // rebootURLComponents.path = @"/api/device/control";
            
            NSMutableURLRequest *rebootRequest = [NSMutableURLRequest requestWithURL:[rebootURLComponents URL]];
            
            [rebootRequest setHTTPMethod:@"POST"];
            
            [rebootRequest setHTTPBody:[@"<?xml version:\"1.0\" encoding=\"UTF-8\"?><request><Control>1</Control></request>" dataUsingEncoding:NSUTF8StringEncoding]];
            [rebootRequest setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
            
            // NSURLSession *rebootSession = [NSURLSession sharedSession];
            
            NSURLSessionDataTask *rebootTask = [[NSURLSession sharedSession] dataTaskWithRequest:rebootRequest];
            [rebootTask resume];
        }
    }];
    
    [loginTask resume];
}

- (void)updateSignalStrength:(id)sender
{
    if (!_hsmStatus) {
        _hsmStatus = [[HSMStatus alloc] init];
    }
    
    [self.hsmStatus getUpdatedStatusWithCompletionHandler:^(NSDictionary *statuses, NSError *error) {
        if (statuses) {
            connectionTypes = [NSMutableDictionary dictionaryWithObjects:@[@"3G", @"2G"] forKeys:@[@"2", @"1"]];
            [statusItem setImage:[NSImage imageNamed:[[NSArray arrayWithObjects:@"Silver", [statuses valueForKey:@"SignalIcon"], @"Bars", nil] componentsJoinedByString:@"_"]]];
            [statusItem setTitle:[connectionTypes valueForKey:[statuses valueForKey:@"ServiceStatus"]]];
            
            [signalStrengthMenuItem setTitle:[[NSArray arrayWithObjects:@"Signal Strength:", [statuses valueForKey:@"SignalStrength"], nil] componentsJoinedByString:@" "]];
            [wanIpMenuItem setTitle:[[NSArray arrayWithObjects:@"WAN IP:", [statuses valueForKey:@"WanIPAddress"], nil] componentsJoinedByString:@" "]];
            [usersMenuItem setTitle:[[NSArray arrayWithObjects:@"Wifi Users:", [statuses valueForKey:@"CurrentWifiUser"], nil] componentsJoinedByString:@" "]];
            
            NSString *connectionType = [statuses valueForKey:@"ServiceStatus"];
            NSString *connectionTypeFmt = [connectionTypes valueForKey:connectionType];
            
            [connectionTypeMenuItem setTitle:[[NSArray arrayWithObjects:@"Connection Type:", connectionTypeFmt, nil] componentsJoinedByString:@" "]];
        } else {
            [statusItem setImage:nil];
            [statusItem setTitle:@"Offline"];
        }
    }];

}

@end
