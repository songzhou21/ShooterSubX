//
//  hashMD5.m
//  ShooterSubD
//
//  Created by Song Zhou on 5/29/14.
//  Copyright (c) 2014 SongZhou. All rights reserved.
//

#import "hashMD5.h"
#import "NSData_MD5.h"

@implementation hashMD5:NSObject
@synthesize length, temp, fh, buff;

- (NSString *)hash_MD5:(NSURL *)filePath {
    
    // Store each section of hash value.
    temp = [NSMutableArray array];
    
    
    // Read file from path.
    fh = [NSFileHandle fileHandleForReadingFromURL:filePath error:NULL];
   
    
    if (fh) {
        // Length of file.
        length = [fh seekToEndOfFile];
        
        // Hash 4K data at 4K position.
        [fh seekToFileOffset:4096];
        buff = [fh readDataOfLength:4096];
        // Calculates hash value of this section and save it to temp array.
        [temp addObject:[buff MD5]];
        
        // At 2 / 3 length of file.
        [fh seekToFileOffset:length * 2 / 3];
        buff = [fh readDataOfLength:4096];
        [temp addObject:[buff MD5]];
        
        // At 1 / 3 length of file.
        [fh seekToFileOffset:length * 1 / 3];
        buff = [fh readDataOfLength:4096];
        [temp addObject:[buff MD5]];
        
        // At length - 8K position;
        [fh seekToFileOffset:length - 8192];
        buff = [fh readDataOfLength:4096];
        [temp addObject:[buff MD5]];
        
        // Convert the array to string, separated with semicolon.
        return [temp componentsJoinedByString:@";"];
        
    } else {
        NSLog(@"fileHandle is nil");
        return nil;
    }
    
}

@end
