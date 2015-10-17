//
//  hashMD5.h
//  ShooterSubD
//
//  ---
// Using NSData Category method MD5 calculte the MD5 hash value of the file
// File divided into four section.
//  ---
//
//  Created by Song Zhou on 5/29/14.
//  Copyright (c) 2014 SongZhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface hashMD5 : NSObject

- (NSString *)hash_MD5:(NSURL *)filePath;

@end
