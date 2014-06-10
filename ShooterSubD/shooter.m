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


@synthesize videoHash, dict, encodedURL, linkType, Data;
@synthesize fileName, downloadURL;


// Get the shooter URL value.
+ (char *)shooterURL {
    return shooterURL;
}


- (id)init {
    self = [super init];
    if (self) {
        Data = [[NSMutableData alloc] init];
        
       // The link to download subtitle and type info in the array.
       linkType = [[NSMutableArray alloc] init];
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
        
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        
        // Initialize an operation queue.
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        // Send an asynchronous request.
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:queue
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   bool isDownloadSuccessful=false;
                                   if (data!=nil)
                                   {
                                       
                                       NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                              options:0
                                                                                                error:nil];
                                       NSDictionary *files = [[NSDictionary alloc] init];
                                   
                                       if (jsonObject) {
                                       // For each Subtitle.
                                           for (NSDictionary *dict1 in jsonObject)
                                           {
                                           // For each File cantains link and type info.
                                               if ([[dict1 objectForKey:@"Delay"]isEqualToNumber:[NSNumber numberWithInt:0]])
                                               {
                                                   files= [dict1 objectForKey:@"Files"];
                                                   for (NSDictionary *dict2 = [[NSDictionary alloc] init] in files)
                                                   {
                                                       [linkType addObject:dict2];
                                                   }
                                                   if ([self startDownload:filePath])
                                                   {
                                                       isDownloadSuccessful=true;
                                                   }
                                               }
                                               else {
                                                        NSLog(@"delay too much, delay:%@", [dict1 objectForKey:@"Delay"]);
                                                    }
                                               
                                           }
                                           
                                       }else {
                                           NSLog(@"No jsonObject");
                                       }
                                   }
                                   if (isDownloadSuccessful)
                                   {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           //notification post a notification ThreadFinish with filePath
                                           NSDictionary *userInfo = [NSDictionary dictionaryWithObject:filePath forKey:@"filePath"];
                                           [[NSNotificationCenter defaultCenter] postNotificationName: @"DownloadThreadFinish" object:nil userInfo:userInfo];
                                       });
                                       
                                   }
                                   else
                                   {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           //notification post a notification ThreadFinish with filePath
                                           NSDictionary *userInfo = [NSDictionary dictionaryWithObject:filePath forKey:@"filePath"];
                                           [[NSNotificationCenter defaultCenter] postNotificationName: @"DownloadThreadFail" object:nil userInfo:userInfo];
                                       });
                                       
                                   }
                                }];
    
        
    }else {
        NSLog(@"filePath is nil");
        dispatch_async(dispatch_get_main_queue(), ^{
            //notification post a notification ThreadFinish with filePath
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:filePath forKey:@"filePath"];
            [[NSNotificationCenter defaultCenter] postNotificationName: @"DownloadThreadFail" object:nil userInfo:userInfo];
        });
    }
    
    
}


- (BOOL) startDownload:(NSURL *)filaPath{
    BOOL downloaded = false;
    
        for (int i = 0; i < [linkType count]; i++) {
            NSDictionary *dict_l = [linkType objectAtIndex:i];
            
            if ([[dict_l objectForKey:@"Ext"]  isEqual: @"ass"]) {
                // Start downloading from 'Link', which is get from key 'Ext'.
                if ([self download:[dict_l objectForKey:@"Link"]
                            filePath:filaPath
                           extention:@"ass"])
                {
                    // Mark downloaded is ture, if ASS subtitle available.
                    downloaded = true;
                    break;
                }
            }
            
        }
    
    // If ASS subtitle is not available.
        if (!downloaded) {
            for (int i = 0; i < [linkType count]; i++) {
            NSDictionary *dict_l = [linkType objectAtIndex:i];

                if ([[dict_l objectForKey:@"Ext"]  isEqual: @"srt"]) {
                    if ([self download:[dict_l objectForKey:@"Link"]
                               filePath:filaPath
                               extention:@"srt"])
                        {
                            downloaded = true;
                            break;
                        }
                }

            }
        }
    return downloaded;
}

- (BOOL)download:(NSString*)URL
        filePath:(NSURL *)filePath
       extention:(NSString *)ext {
    
    downloadURL = [NSURL URLWithString:URL];
    
    // Filename contain subtitle type extention.
    fileName = [NSString stringWithFormat:@"%@.%@",[filePath URLByDeletingPathExtension], ext];
    NSLog(@"filenale: %@", fileName);
    NSLog(@"download_url: %@", downloadURL);
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:downloadURL];
    
    NSURLResponse * response = nil;
    NSError * connectionError = nil;
    NSData*subData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&connectionError];
    
    if (subData==nil) return false;
    
    NSError *error=nil;
    BOOL written = [subData writeToURL:[NSURL URLWithString:fileName]
                             options:0
                               error:&error];
    if (!written) {
        NSLog(@"write failed: %@", [error localizedDescription]);
        return false;
    }
    return true;
}



@end
