//
//  CAPreferencesWindowController.h
//  Caffeine
//
//  Created by Dominic Rodemer on 11.07.22.
//

#import <Cocoa/Cocoa.h>

@interface CAPreferencesWindowController : NSWindowController
{
    NSImageView *iconView;
    
    NSTextField *informationTextField;
    NSTextField *instructionsTextField;
    
    NSTextField *durationsTextField;
    NSPopUpButton *durationButton;
    
    NSButton *activateAtLaunchButton;
    NSButton *deactivateAtOnManualSleepButton;
    NSButton *showAtLaunchButton;
    
    NSButton *quitButton;
    NSButton *closeButton;
}

@property (nonatomic, strong) IBOutlet NSImageView *iconView;

@property (nonatomic, strong) IBOutlet NSTextField *informationTextField;
@property (nonatomic, strong) IBOutlet NSTextField *instructionsTextField;

@property (nonatomic, strong) IBOutlet NSTextField *durationsTextField;
@property (nonatomic, strong) IBOutlet NSPopUpButton *durationButton;

@property (nonatomic, strong) IBOutlet NSButton *activateAtLaunchButton;
@property (nonatomic, strong) IBOutlet NSButton *deactivateOnManualSleepButton;
@property (nonatomic, strong) IBOutlet NSButton *showAtLaunchButton;

@property (nonatomic, strong) IBOutlet NSButton *quitButton;
@property (nonatomic, strong) IBOutlet NSButton *closeButton;

@end
