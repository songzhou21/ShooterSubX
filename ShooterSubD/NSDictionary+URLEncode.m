//
//  NSDictionary+URLEncode.m
//  ShooterSubD
//
//  Created by Song Zhou on 5/30/14.
//  Copyright (c) 2014 SongZhou. All rights reserved.
//

#import "NSDictionary+URLEncode.h"

@implementation NSDictionary (URLEncode)

- (NSString *)urlEncoded {
    NSString * currKey;
    NSString * currValue;
    NSMutableString *result = [[NSMutableString alloc] init];
    
    // Convert dictionary to utf-8 encoded url.
    for (NSString *key in self) {
        
        // Convert 'key' string by adding percent escpaes.
        currKey = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)key, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8));
        
        // Convert 'value' string by adding percent escpaes.
        currValue = [self objectForKey:key];
        
        currValue= CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)currValue, NULL,  CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8));
        
        if ([result length] > 0) {
            [result appendString:@"&"];
        }
        
        [result appendString:[NSString stringWithFormat:@"%@=%@", currKey, currValue]];
        
    }
    
    return result;
}

@end
