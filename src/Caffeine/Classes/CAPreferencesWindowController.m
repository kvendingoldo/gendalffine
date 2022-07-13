//
//  CAPreferencesWindowController.m
//  Caffeine
//
//  Created by Dominic Rodemer on 11.07.22.
//

#import "CAPreferencesWindowController.h"

@implementation CAPreferencesWindowController

@synthesize iconView;
@synthesize informationTextField;
@synthesize instructionsTextField;
@synthesize durationsTextField;
@synthesize durationButton;
@synthesize activateAtLaunchButton;
@synthesize deactivateOnManualSleepButton;
@synthesize showAtLaunchButton;
@synthesize quitButton;
@synthesize closeButton;

- (id)init
{
    if (self = [super initWithWindowNibName:@"CAPreferencesWindowController" owner:self])
    {
        
    }
    
    return self;
}

- (void)loadWindow
{
    [super loadWindow];
    
    [durationsTextField sizeToFit];
    [durationButton sizeToFit];
    [activateAtLaunchButton sizeToFit];
    [deactivateOnManualSleepButton sizeToFit];
    [showAtLaunchButton sizeToFit];
    [closeButton sizeToFit];
    [quitButton sizeToFit];
    
    CGFloat toolbarHeight = self.window.frame.size.height - self.window.contentLayoutRect.size.height;
    NSEdgeInsets edgeInsets = NSEdgeInsetsMake(20.0, 20.0, 13.0, 20.0);
    
    CGFloat textX = edgeInsets.left + iconView.frame.size.width + edgeInsets.right;
    CGFloat textWidth = MAX(MAX(activateAtLaunchButton.frame.size.width, deactivateOnManualSleepButton.frame.size.width), showAtLaunchButton.frame.size.width);

    CGFloat windowHeight = 0.0;
    CGFloat windowWidth = textX + textWidth + edgeInsets.left;
        
    windowHeight += edgeInsets.bottom;
    quitButton.frame = NSMakeRect(13.0,
                                  windowHeight,
                                  quitButton.frame.size.width,
                                  quitButton.frame.size.height);
    closeButton.frame = NSMakeRect(windowWidth - 13.0 - closeButton.frame.size.width,
                                   windowHeight,
                                   closeButton.frame.size.width,
                                   closeButton.frame.size.height);
    windowHeight += quitButton.frame.size.height;
    
    
    windowHeight += edgeInsets.bottom;
    showAtLaunchButton.frame = NSMakeRect(textX,
                                          windowHeight,
                                          showAtLaunchButton.frame.size.width,
                                          showAtLaunchButton.frame.size.height);
    windowHeight += showAtLaunchButton.frame.size.height + 4.0;
    deactivateOnManualSleepButton.frame = NSMakeRect(textX,
                                                     windowHeight,
                                                     deactivateOnManualSleepButton.frame.size.width,
                                                     deactivateOnManualSleepButton.frame.size.height);
    windowHeight += deactivateOnManualSleepButton.frame.size.height + 4.0;
    activateAtLaunchButton.frame = NSMakeRect(textX,
                                              windowHeight,
                                              activateAtLaunchButton.frame.size.width,
                                              activateAtLaunchButton.frame.size.height);
    windowHeight += activateAtLaunchButton.frame.size.height + 4.0;
    durationsTextField.frame = NSMakeRect(textX,
                                          windowHeight,
                                          durationsTextField.frame.size.width,
                                          durationButton.frame.size.height);
    durationButton.frame = NSMakeRect(textX + durationsTextField.frame.size.width + 4.0,
                                      windowHeight,
                                      durationButton.frame.size.width,
                                      durationButton.frame.size.height);
    windowHeight += durationButton.frame.size.height;
    
    windowHeight += 3*edgeInsets.bottom;
    NSSize instructionsTextFieldSize = [instructionsTextField sizeThatFits:NSMakeSize(textWidth, CGFLOAT_MAX)];
    instructionsTextField.frame = NSMakeRect(textX,
                                             windowHeight,
                                             textWidth,
                                             instructionsTextFieldSize.height);
    windowHeight += instructionsTextField.frame.size.height + edgeInsets.bottom;
    NSSize informationTextFieldSize = [informationTextField sizeThatFits:NSMakeSize(textWidth, CGFLOAT_MAX)];
    informationTextField.frame = NSMakeRect(textX,
                                            windowHeight,
                                            textWidth,
                                            informationTextFieldSize.height);
    windowHeight += informationTextField.frame.size.height;
    
    iconView.frame = NSMakeRect(edgeInsets.left,
                                windowHeight - iconView.frame.size.height,
                                iconView.frame.size.height,
                                iconView.frame.size.width);
    
    windowHeight += edgeInsets.top + toolbarHeight;
    [self.window setFrame:NSMakeRect(0.0, 0.0, windowWidth, windowHeight) display:NO];
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
