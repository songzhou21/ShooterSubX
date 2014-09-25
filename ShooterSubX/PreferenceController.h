//
//  PreferenceController.h
//  ShooterSubX
//
//  Created by Song Zhou on 7/9/14.
//  Copyright (c) 2014 SongZhou. All rights reserved.
//

#import <Cocoa/Cocoa.h>
extern NSString *const SZSubTypeKey;

@interface PreferenceController : NSWindowController {
    IBOutlet NSPopUpButton *subTypeButton;
    
}
-(IBAction)changeSubTypePriority:(id)sender;

// Preferences accessor methods.
+(NSString *)preferenceSubType;
+(void)setPreferenceSubType:(NSString *)subType;

@end
