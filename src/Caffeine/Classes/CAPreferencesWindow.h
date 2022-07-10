//
//  CAPreferencesWindow.h
//  Caffeine
//
//  Created by Dominic Rodemer on 18.06.22.
//

#import <Cocoa/Cocoa.h>

@interface CAPreferencesWindow : NSWindow
{
    NSPopUpButton *durationButton;
    NSButton *activateAtLaunchButton;
    NSButton *deactivateAtOnManualSleepButton;
    NSButton *showAtLaunchButton;
}

@property (nonatomic, strong) IBOutlet NSPopUpButton *durationButton;
@property (nonatomic, strong) IBOutlet NSButton *activateAtLaunchButton;
@property (nonatomic, strong) IBOutlet NSButton *deactivateOnManualSleepButton;
@property (nonatomic, strong) IBOutlet NSButton *showAtLaunchButton;


@end
