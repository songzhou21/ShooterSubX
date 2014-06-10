//
//  shooter.h
//  ShooterSubD
//  ---
// Deal with Shooter subtitle API.
//  ---
//
//  Created by Song Zhou on 5/30/14.
//  Copyright (c) 2014 SongZhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "hashMD5.h"
#import "NSData_MD5.h"
#import "NSDictionary+URLEncode.h"


@interface shooter : NSObject


@property (nonatomic,strong) NSString * videoHash;
@property (nonatomic,strong) NSDictionary * dict;
@property (nonatomic,strong) NSString * encodedURL;
@property (nonatomic,strong) NSURL *downloadURL;
@property (nonatomic,strong) NSMutableArray * linkType;
@property (nonatomic,strong) NSMutableData * Data;
//@property NSURLConnection * connection;
@property (nonatomic,strong) NSString* fileName;


// Shooter subtitle API URL.
+ (char *)shooterURL;

// Deal some stuff before downloading.
- (void)subDownloader:(NSURL*) filePath;

// Start downloading subtitle.
- (BOOL)startDownload:(NSURL *)filaPath;

// Real downloading.
- (BOOL)download:(NSString *)URL
        filePath:(NSURL *)filePath
       extention:(NSString *)ext;


@end
