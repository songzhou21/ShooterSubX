//
//  SZAppDelegate.h
//  ShooterSubX
//
//  Created by Song Zhou on 6/1/14.
//  Copyright (c) 2014 SongZhou. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SZFile.h"

@class PreferenceController;

@interface SZAppDelegate : NSObject <NSApplicationDelegate,NSUserNotificationCenterDelegate> {
    PreferenceController *preferenceController;
}

@property (assign) IBOutlet NSWindow *window;

// Preference Action methods.
-(IBAction)showPreferencePanel:(id)sender;

@end
