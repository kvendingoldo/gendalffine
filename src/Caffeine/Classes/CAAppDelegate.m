//
//  CAAppDelegate.m
//  Caffeine
//
//  Created by Tomas Franzén on 2006-05-20.
//  Copyright 2006 Lighthead Software. All rights reserved.
//

#import "CAAppDelegate.h"

@implementation CAAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
    
    // Prevent the computer from going to sleep when another account was active.
    userSessionIsActive = YES;
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
                                                           selector:@selector(workspaceSessionDidResignActiveNotification:)
                                                               name:NSWorkspaceSessionDidResignActiveNotification
                                                             object:nil];
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
                                                           selector:@selector(workspaceSessionDidBecomeActiveNotification:)
                                                               name:NSWorkspaceSessionDidBecomeActiveNotification
                                                             object:nil];
    
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
                                                           selector:@selector(workspaceWillSleepNotification:)
                                                               name:NSWorkspaceWillSleepNotification
                                                             object:nil];
        
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                                                        forKey:@"CASuppressLaunchMessage"]];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"CASuppressLaunchMessage"])
        [self showPreferences:nil];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
{
    [self showPreferences:nil];
    return NO;
}

- (void)awakeFromNib
{
    statusItemMenuIcon = [NSImage imageNamed:@"inactive"];
    statusItemMenuIcon.template = YES;
    statusItemMenuIconActive= [NSImage imageNamed:@"active"];
    statusItemMenuIconActive.template = YES;
    
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    statusItem.button.image = statusItemMenuIcon;
    [statusItem.button sendActionOn:NSEventMaskLeftMouseUp|NSEventMaskRightMouseUp];
    [statusItem.button setAction:@selector(statusItemAction:)];
    [statusItem.button setTarget:self];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"CAActivateAtLaunch"])
        [self activate];
}



#pragma mark Actions
#pragma mark ---
- (void)statusItemAction:(id)sender
{
    NSEvent *event = NSApp.currentEvent;
    if (event.type == NSEventTypeRightMouseUp)
        [statusItem popUpStatusItemMenu:menu];
    else
        [self toggleActive:sender];
        
}

- (IBAction)activateWithTimeout:(id)sender
{
    int minutes = (int)[(NSMenuItem *)sender tag];
    int seconds = minutes*60;
    
    if(seconds == -60)
        seconds = 2;
    if(minutes)
        [self activateWithTimeoutDuration:seconds];
    else
        [self activate];
}

- (IBAction)showAbout:(id)sender
{
    [NSApp activateIgnoringOtherApps:YES];
    
    NSString *credits = NSLocalizedString(@"© 2006 Tomas Franzén \n © 2018 Michael Jones \n © 2022 Dominic Rodemer \n\n Source code: \n https://github.caffeine-app.net", @"");
    [NSApp orderFrontStandardAboutPanelWithOptions:@{@"Copyright" : credits}];
}

- (IBAction)showPreferences:(id)sender
{
    [NSApp activateIgnoringOtherApps:YES];
    [firstTimeWindow center];
    [firstTimeWindow makeKeyAndOrderFront:sender];
}



#pragma mark Accessors
#pragma mark ---
- (BOOL)isActive
{
    return isActive;
}



#pragma mark Public
#pragma mark ---
- (void)activate
{
    [self activateWithTimeoutDuration:0];
}

- (void)activateWithTimeoutDuration:(NSTimeInterval)interval
{
    if(timeoutTimer)
        [timeoutTimer invalidate];
    timeoutTimer = nil;
    
    if(interval > 0)
        timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                        target:self
                                                      selector:@selector(timeoutReached:)
                                                      userInfo:nil
                                                       repeats:NO];
    
    isActive = YES;
    statusItem.button.image = statusItemMenuIconActive;
}

- (void)deactivate
{
    isActive = NO;
    
    if(timeoutTimer)
        [timeoutTimer invalidate];
    timeoutTimer = nil;
    
    statusItem.button.image = statusItemMenuIcon;
}

- (void)toggleActive:(id)sender
{
    if(timeoutTimer) [timeoutTimer invalidate];
    timeoutTimer = nil;
    
    if(isActive)
    {
        [self deactivate];
    }
    else
    {
        int defaultMinutesDuration = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"CADefaultDuration"];
        int seconds = defaultMinutesDuration*60;
        if(seconds == -60) seconds = 2;
        if(defaultMinutesDuration)
            [self activateWithTimeoutDuration:seconds];
        else
            [self activate];
    }
}



#pragma mark Private
#pragma mark ---
- (void)timeoutReached:(NSTimer*)timer
{
    [self deactivate];
}

- (void)timer:(NSTimer*)timer
{
    if(isActive && userSessionIsActive)
    {
        if (sleepAssertionID)
            IOPMAssertionRelease(sleepAssertionID);
        sleepAssertionID = 0;
        IOPMAssertionCreateWithDescription(kIOPMAssertPreventUserIdleDisplaySleep,
                                           CFSTR("Caffeine prevents sleep"),
                                           NULL,
                                           NULL,
                                           NULL,
                                           0,
                                           NULL,
                                           &sleepAssertionID);
    }
}

- (void)menuNeedsUpdate:(NSMenu *)m
{
    if(isActive)
    {
        [infoMenuItem setHidden:NO];
        [infoSeparatorItem setHidden:NO];
        
        if(timeoutTimer)
        {
            NSTimeInterval left = [[timeoutTimer fireDate] timeIntervalSinceNow];
            if(left >= 3600)
                [infoMenuItem setTitle:[NSString stringWithFormat:@"%02d:%02d left", (int)(left/3600), (int)(((int)left%3600)/60)]];
            else if(left >= 60)
                [infoMenuItem setTitle:[NSString stringWithFormat:@"%d minutes left", (int)(left/60)]];
            else
                [infoMenuItem setTitle:[NSString stringWithFormat:@"%d seconds left", (int)left]];
        }
        else
        {
            [infoMenuItem setTitle:@"Caffeine is active"];
        }
    }
    else
    {
        [infoMenuItem setHidden:YES];
        [infoSeparatorItem setHidden:YES];
    }
}



#pragma mark NSWorkspace Notifications
#pragma mark ---
- (void)workspaceSessionDidResignActiveNotification:(NSNotification *)notification
{
    userSessionIsActive = NO;
}

- (void)workspaceSessionDidBecomeActiveNotification:(NSNotification *)notification
{
    userSessionIsActive = YES;
}

- (void)workspaceWillSleepNotification:(NSNotification *)notification
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"CADeactivateOnManualSleep"])
    {
        [self deactivate];
    }
}

@end
