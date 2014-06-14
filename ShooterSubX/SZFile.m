//
//  SZFile.m
//  ShooterSubX
//
//  Created by Song Zhou on 6/1/14.
//  Copyright (c) 2014 SongZhou. All rights reserved.
//

#import "SZFile.h"

@implementation SZFile

- (void)creatFromFilePathString:(NSString *)fileNameString {
    
    // Convert the String to a escaped / encoded string.
    
    // Create a URL from the encoded string.
    _fileURL = [NSURL fileURLWithPath:fileNameString];
    NSLog(@"_fileURL: %@", _fileURL);
    
    // Create a file manager to get the file details.
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary *attribs = [fm attributesOfItemAtPath:_fileURL.path error:nil];
    
    // Convert the filesize attribute to a bytes / KB / MB formatted string.
    _fileSize = [NSByteCountFormatter stringFromByteCount:[attribs fileSize] countStyle:NSByteCountFormatterCountStyleFile];
    _fileBytes=[NSNumber numberWithUnsignedLong:[attribs fileSize]];
    _fileName = _fileURL.lastPathComponent;
    
}
@end
