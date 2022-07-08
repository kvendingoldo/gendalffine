//
//  CAAppDelegate.h
//  Caffeine
//
//  Created by Tomas Franzén on 2006-05-20.
//  Copyright 2006 Lighthead Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <IOKit/pwr_mgt/IOPMLib.h>

@interface CAAppDelegate : NSObject <NSApplicationDelegate>
{
    BOOL isActive;
    BOOL userSessionIsActive;
    NSTimer *timer;
    NSTimer *timeoutTimer;
    IOPMAssertionID sleepAssertionID;
    
    NSStatusItem *statusItem;
    NSImage *statusItemMenuIcon;
    NSImage *statusItemMenuIconActive;
    
    IBOutlet NSMenu *menu;
    IBOutlet NSWindow *firstTimeWindow;
    IBOutlet NSMenuItem *infoMenuItem;
    IBOutlet NSMenuItem *infoSeparatorItem;
}

@property (nonatomic, assign, readonly) BOOL isActive;

- (IBAction)showAbout:(id)sender;
- (IBAction)showPreferences:(id)sender;
- (IBAction)activateWithTimeout:(id)sender;

- (void)activate;
- (void)activateWithTimeoutDuration:(NSTimeInterval)interval;
- (void)deactivate;
- (void)toggleActive:(id)sender;

@end

