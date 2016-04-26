//
//  hsmAppDelegate.h
//  Huawei Signal Monitor
//
//  Created by Jake Lee Kennedy on 02/09/2014.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface hsmAppDelegate : NSObject <NSApplicationDelegate> {
    //NSWindow *window;
    IBOutlet NSMenu *statusMenu;
    NSStatusItem * statusItem;
    IBOutlet NSMenuItem *openPageMenuItem;
    IBOutlet NSMenuItem *rebootMenuItem;
    IBOutlet NSMenuItem *quitMenuItem;
    IBOutlet NSMenuItem *signalStrengthMenuItem;
    IBOutlet NSMenuItem *wanIpMenuItem;
    IBOutlet NSMenuItem *usersMenuItem;
    IBOutlet NSMenuItem *connectionTypeMenuItem;
    NSMutableDictionary *connectionTypes;
}

//@property (strong, nonatomic) NSStatusItem *statusItem;
//@property (assign) IBOutlet NSWindow *window;


@end
