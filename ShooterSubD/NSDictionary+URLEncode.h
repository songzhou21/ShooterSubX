//
//  NSDictionary+URLEncode.h
//  ShooterSubD
//
//  ---
// Convert string to UTF-8 encoded URL
// With percent escpaes.
//  ---
//
//  Created by Song Zhou on 5/30/14.
//  Copyright (c) 2014 SongZhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (URLEncode)

-(NSString *)urlEncoded;

@end
