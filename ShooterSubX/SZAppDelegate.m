//
//  SZAppDelegate.m
//  ShooterSubX
//
//  Created by Song Zhou on 6/1/14.
//  Copyright (c) 2014 SongZhou. All rights reserved.
//

#import "SZAppDelegate.h"
#import "PreferenceController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "Countly.h"

@implementation SZAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center
     shouldPresentNotification:(NSUserNotification *)notification
{
    return YES;
}
/**
 *  appDelegate that perform that reshow of the window when the user press close button on the left up corner
 *
 *  @param theApplication theApplication description
 *  @param flag           if the app find any visible window
 *
 *  @return if we need to perform the normal task
 */
- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
{
    // add CrashLytics
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{ @"NSApplicationCrashOnExceptions": @YES }];
    [Fabric with:@[[Crashlytics class]]];

	if (flag) {
		return NO;
	}
    else
	{
        [self.window makeKeyAndOrderFront:self];
        return YES;
	}
    
}

-(IBAction)showPreferencePanel:(id)sender {
    if (!preferenceController) {
        preferenceController = [[PreferenceController alloc] init];
    }
    
    NSLog(@"showing %@", preferenceController);
    [preferenceController showWindow:self];
    
}

// Register for user defaults keys.
+(void)initialize {
    // Create a dictionary.
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
    // Set object and key for defaultValues.
    [defaultValues setObject:[NSString stringWithFormat:@"ASS"] forKey:SZSubTypeKey];
    // Register defaultValues dictionary.
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
    NSLog(@"registered defaults: %@", defaultValues);
}
@end

