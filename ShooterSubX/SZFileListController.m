//
//  SZFileListController.m
//  ShooterSubX
//
//  Created by Song Zhou on 6/1/14.
//  Copyright (c) 2014 SongZhou. All rights reserved.
//

#import "SZFileListController.h"
#import "SZFile.h"
#import "shooter.h"

@implementation SZFileListController {
    
}
    

- (id)init {
    self = [super init];
    if (self) {
        fileListArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)fileStuff:(NSArray *)files {
    NSLog(@"do something called");
    
    for (id file in files) {
        NSLog(@"the file is: %@",file);
        
        SZFile *f = [[SZFile alloc] init];
        [f creatFromFilePathString:file];
        
        [fileListArray addObject:f];
        NSLog(@"fileListArray:%@", fileListArray);
        [fileListView reloadData];
    }
}

#pragma mark -- Actions
- (IBAction)remove:(id)sender {
    NSInteger selectedRow = [fileListView selectedRow];
    
    if (selectedRow >= 0) {
        [fileListArray removeObjectAtIndex:selectedRow];
        [fileListView reloadData];
    }
}

- (IBAction)downloadAll:(id)sender {
    if ([fileListArray count] > 0) {
        for (id file in fileListArray) {
            shooter *task = [[shooter alloc] init];
            
            // Prepare for downloading.
            [task subDownloader:[file fileURL]];
            
            // Start downloading.
            [task startDownload:[file fileURL]];
            
        }
    }
}

#pragma mark -- NSTableView protocol methods
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [fileListArray count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    SZFile *p = [fileListArray objectAtIndex:row];
    NSString *identifier = [tableColumn identifier];
    
    return [p valueForKey:identifier];
}



@end
