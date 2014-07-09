//
//  SZFile.h
//  ShooterSubX
//
//  Created by Song Zhou on 6/1/14.
//  Copyright (c) 2014 SongZhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZFile : NSObject



@property (nonatomic, copy) NSString * fileName;
@property (nonatomic, copy) NSString * fileSize;
@property (nonatomic, copy) NSNumber *fileBytes;//original fileSize counting by bytes for sorting feature
@property (nonatomic, copy) NSURL * fileURL;

- (void)creatFromFilePathString:(NSString *)fileNameString;

@end

