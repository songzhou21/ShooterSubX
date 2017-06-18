//
//  hashMD5.m
//  ShooterSubD
//
//  Created by Song Zhou on 5/29/14.
//  Copyright (c) 2014 SongZhou. All rights reserved.
//

#import "hashMD5.h"
#import "NSData_MD5.h"

@interface hashMD5 ()
    
@property unsigned long long length;
@property NSFileHandle *fileHandler;
@property NSData *buffer;


@end

@implementation hashMD5:NSObject

- (NSString *)hash_MD5:(NSURL *)filePath
{
    // Read file from path.
    self.fileHandler = [NSFileHandle fileHandleForReadingFromURL:filePath error:NULL];
   
    if (self.fileHandler) {
        // Length of file.
        self.length = [self.fileHandler seekToEndOfFile];
        NSArray *fileOfffset= @[@"4096", [NSNumber numberWithLongLong:self.length * 2/3], [NSNumber numberWithLongLong:self.length * 1/3], [NSNumber numberWithLongLong:self.length - 8192]];
        NSUInteger readLength = 4096;
        NSMutableArray *resultString = [NSMutableArray new];
        
        for (NSNumber *offset in fileOfffset) {
            [self.fileHandler seekToFileOffset:[offset longLongValue]];
            self.buffer = [self.fileHandler readDataOfLength:readLength];
            [resultString addObject:[self.buffer MD5]];
        }
        
        
        // Convert the array to string, separated with semicolon.
        return [resultString componentsJoinedByString:@";"];
        
    } else {
        NSLog(@"fileHandler is nil");
        return nil;
    }
    
}

@end
