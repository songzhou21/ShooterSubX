//
//  PreferenceController.m
//  ShooterSubX
//
//  Created by Song Zhou on 7/9/14.
//  Copyright (c) 2014 SongZhou. All rights reserved.
//

#import "PreferenceController.h"

// Keys for users defaults.
NSString * const SZSubTypeKey = @"SZSubTypeKey";

@interface PreferenceController ()

@end

@implementation PreferenceController

-(id)init {
    self = [super initWithWindowNibName:@"Preferences"];
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    NSLog(@"Preferences Nib file is loaded");
    
    [subTypeButton selectItemWithTitle:[PreferenceController preferenceSubType]];
    
}

-(IBAction)changeSubTypePriority:(id)sender {
    [PreferenceController setPreferenceSubType:[subTypeButton titleOfSelectedItem]];
}

// Preferences accessor methods.
+(NSString *)preferenceSubType {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog (@"get defaults: %@",[defaults stringForKey:SZSubTypeKey]);
    
    return [defaults stringForKey:SZSubTypeKey];
}

+(void)setPreferenceSubType:(NSString *)subType{
    [[NSUserDefaults standardUserDefaults] setObject:subType forKey:SZSubTypeKey];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog (@"set defaults: %@",[defaults stringForKey:SZSubTypeKey]);
}

@end
