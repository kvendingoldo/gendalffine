//
//  CAPreferencesWindow.m
//  Caffeine
//
//  Created by Dominic Rodemer on 18.06.22.
//

#import "CAPreferencesWindow.h"

@implementation CAPreferencesWindow

@synthesize durationButton;
@synthesize activateAtLaunchButton;
@synthesize deactivateOnManualSleepButton;
@synthesize showAtLaunchButton;

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    NSControlStateValue suppressAtLaunchState = (![[NSUserDefaults standardUserDefaults] boolForKey:@"CASuppressLaunchMessage"]) ? NSControlStateValueOn : NSControlStateValueOff;
    [self.showAtLaunchButton setState:suppressAtLaunchState];
    
    NSControlStateValue activateAtLaunchState = ([[NSUserDefaults standardUserDefaults] boolForKey:@"CAActivateAtLaunch"]) ? NSControlStateValueOn : NSControlStateValueOff;
    [self.activateAtLaunchButton setState:activateAtLaunchState];
    
    NSControlStateValue deactivateOnManualSleepState = ([[NSUserDefaults standardUserDefaults] boolForKey:@"CADeactivateOnManualSleep"]) ? NSControlStateValueOn : NSControlStateValueOff;
    [self.deactivateOnManualSleepButton setState:deactivateOnManualSleepState];
    
    NSInteger duration = [[NSUserDefaults standardUserDefaults] integerForKey:@"CADefaultDuration"];
    [durationButton selectItemWithTag:duration];
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

@end
