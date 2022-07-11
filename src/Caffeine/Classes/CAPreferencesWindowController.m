//
//  CAPreferencesWindowController.m
//  Caffeine
//
//  Created by Dominic Rodemer on 11.07.22.
//

#import "CAPreferencesWindowController.h"

@implementation CAPreferencesWindowController

@synthesize durationButton;
@synthesize activateAtLaunchButton;
@synthesize deactivateOnManualSleepButton;
@synthesize showAtLaunchButton;

- (id)init
{
    if (self = [super initWithWindowNibName:@"CAPreferencesWindowController" owner:self])
    {
        
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    NSControlStateValue suppressAtLaunchState = (![[NSUserDefaults standardUserDefaults] boolForKey:@"CASuppressLaunchMessage"]) ? NSControlStateValueOn : NSControlStateValueOff;
    [showAtLaunchButton setState:suppressAtLaunchState];
    
    NSControlStateValue activateAtLaunchState = ([[NSUserDefaults standardUserDefaults] boolForKey:@"CAActivateAtLaunch"]) ? NSControlStateValueOn : NSControlStateValueOff;
    [activateAtLaunchButton setState:activateAtLaunchState];
    
    NSControlStateValue deactivateOnManualSleepState = ([[NSUserDefaults standardUserDefaults] boolForKey:@"CADeactivateOnManualSleep"]) ? NSControlStateValueOn : NSControlStateValueOff;
    [deactivateOnManualSleepButton setState:deactivateOnManualSleepState];
    
    NSInteger duration = [[NSUserDefaults standardUserDefaults] integerForKey:@"CADefaultDuration"];
    [durationButton selectItemWithTag:duration];
}

- (IBAction)showWindow:(id)sender
{
    [self.window center];
    
    [super showWindow:sender];
}


#pragma mark Actions
#pragma mark ---
- (IBAction)durationButtonAction:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setInteger:durationButton.selectedItem.tag forKey:@"CADefaultDuration"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)activateAtLaunchButtonAction:(id)sender
{
    BOOL activateAtLaunch = (activateAtLaunchButton.state == NSControlStateValueOn) ? YES : NO;
    [[NSUserDefaults standardUserDefaults] setBool:activateAtLaunch forKey:@"CAActivateAtLaunch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)deactivateOnManualSleepButtonAction:(id)sender
{
    BOOL deactivateOnManualSleep = (deactivateOnManualSleepButton.state == NSControlStateValueOn) ? YES : NO;
    [[NSUserDefaults standardUserDefaults] setBool:deactivateOnManualSleep forKey:@"CADeactivateOnManualSleep"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)showAtLaunchButtonAction:(id)sender
{
    BOOL suppressAtLaunch = (showAtLaunchButton.state == NSControlStateValueOff) ? YES : NO;
    [[NSUserDefaults standardUserDefaults] setBool:suppressAtLaunch forKey:@"CASuppressLaunchMessage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)closeButtonAction:(id)sender
{
    [self close];
}

- (IBAction)quitButtonAction:(id)sender
{
    [NSApp terminate:self];
}

@end
