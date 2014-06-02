//
//  shooter.m
//  ShooterSubD
//
//  Created by Song Zhou on 5/30/14.
//  Copyright (c) 2014 SongZhou. All rights reserved.
//

#import "shooter.h"

@implementation shooter

// Shooter API.
static char * shooterURL = "http://shooter.cn/api/subapi.php?";


@synthesize videoHash, dict, encodedURL, linkType, Data, connection;
@synthesize fileName;


// Get the shooter URL value.
+ (char *)shooterURL {
    return shooterURL;
}


- (id)init {
    self = [super init];
    if (self) {
        Data = [[NSMutableData alloc] init];
    }
    
    return self;
}

- (void)subDownloader:(NSURL*) filePath {
    
    
    // Create the hashMD5 instance.
    hashMD5 *hm = [[hashMD5 alloc] init];
    
    // Calculate the hash value of file.
    if (filePath) {
        videoHash = [hm hash_MD5:filePath];
        
        
        dict = [NSDictionary dictionaryWithObjectsAndKeys:@"json", @"format",
                videoHash,@"filehash" , [filePath absoluteString], @"pathinfo", @"Chn", @"lang", nil];
        
        // URL encoded by adding percent escapes.
        encodedURL = [dict urlEncoded];
        
        // Request URL
        NSURL *url = [NSURL URLWithString: [[NSString stringWithUTF8String:shooterURL]stringByAppendingString:encodedURL]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:NULL
                                                        error:&error];
        
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:0
                                                                     error:nil];
        // The link to download subtitle and type info in the array.
        linkType = [[NSMutableArray alloc] init];
        NSDictionary *files = [[NSDictionary alloc] init];
        
        if (jsonObject) {
            // For each Subtitle.
            for (NSDictionary *dict1 in jsonObject) {
                
                
                // For each File cantains link and type info.
                if ([[dict1 objectForKey:@"Delay"]isEqualToNumber:[NSNumber numberWithInt:0]]) {
                    files= [dict1 objectForKey:@"Files"];
                    for (NSDictionary *dict2 = [[NSDictionary alloc] init] in files){
                        [linkType addObject:dict2];
                    }
                }else {
                    NSLog(@"delay too much, delay:%@", [dict1 objectForKey:@"Delay"]);
                }
            }
        }else {
            NSLog(@"No jsonObject");
        }
    }else {
        NSLog(@"filePath is nil");
    }
}

- (void)startDownload:(NSURL *)filaPath{
    BOOL downloaded = false;
    
    shooter *downloader = [[shooter alloc] init];
    
        for (int i = 0; i < [linkType count]; i++) {
            NSDictionary *dict_l = [linkType objectAtIndex:i];
            
            if ([[dict_l objectForKey:@"Ext"]  isEqual: @"ass"]) {
                // Start downloading from 'Link', which is get from key 'Ext'.
                [downloader download:[dict_l objectForKey:@"Link"]
                            filePath:filaPath
                           extention:@"ass"];
                // Mark downloaded is ture, if ASS subtitle available.
                downloaded = true;
                
                break;
            }
            
        }
    
    // If ASS subtitle is not available.
        if (!downloaded) {
            for (int i = 0; i < [linkType count]; i++) {
            NSDictionary *dict_l = [linkType objectAtIndex:i];

                if ([[dict_l objectForKey:@"Ext"]  isEqual: @"srt"]) {
                    [downloader download:[dict_l objectForKey:@"Link"]
                               filePath:filaPath
                               extention:@"srt"];
                    downloaded = true;
                    
                    break;
                }

            }
        }
    
    
}

- (void)download:(NSString*)URL
        filePath:(NSURL *)filePath
       extention:(NSString *)ext {
    
    NSURL *url = [NSURL URLWithString:URL];
    
    // Filename contain subtitle type extention.
    fileName = [NSString stringWithFormat:@"%@.%@",[filePath URLByDeletingPathExtension], ext];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
   connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    
    
}

#pragma mark NSURLConnection delegate methods

// The following are delegate methods for NSURLConnection.

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"connection successful");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    // Almost 16 KiB every appending.
    [Data appendData:data];
   
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSLog(@"connection finish");
    
    NSError *error = nil;
    BOOL written = [Data writeToFile:[fileName stringByRemovingPercentEncoding]
                             options:0
                               error:&error];
    if (!written) {
        NSLog(@"write failed: %@", [error localizedDescription]);
    }
    
    Data = nil;
}

@end
