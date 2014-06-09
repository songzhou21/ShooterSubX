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
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(deleteCorrespondingRow:)
                                                     name:@"ThreadFinish" object:nil];
    }
    
    return self;
}


- (void) searchInFileArrayList:(NSURL *) fileURL
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"self.fileURL= %@",fileURL];
    NSArray *result=[fileListArray filteredArrayUsingPredicate:pred];
    [fileListArray removeObject:[result lastObject]];
    [fileListView reloadData];
}

-(void)deleteCorrespondingRow:(NSNotification *)notification
{
    NSDictionary *userInfo=notification.userInfo;
    NSURL*fileAddr=[userInfo objectForKey:@"filePath"];
    [self searchInFileArrayList:fileAddr];
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
            
            // Prepare and start to downloading.
            [task subDownloader:[file fileURL]];
            
        }
            // Remove file frome fileListView each Downloading process.
            //[fileListArray removeAllObjects];
            //[fileListView reloadData];
        
    }
}



- (IBAction)openHelper:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:@"http://gogozs.github.io/projects/ShooterSubX.html"]];
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
