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
    unsigned int failCounter;
    unsigned int successCounter;
}
    

- (id)init {
    self = [super init];
    if (self) {
        fileListArray = [[NSMutableArray alloc] init];
        //add listener to catch the downloadfinish message
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getFinishMessage:)
                                                     name:@"DownloadThreadFinish" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getFailMessage:)
                                                     name:@"DownloadThreadFail" object:nil];
    }
    
    return self;
}

#pragma mark -- postTheDownloadNotification
-(void) postTheFinishNotification
{
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Sub Download Tasks Finish";
    notification.informativeText = [NSString stringWithFormat:@"Success:%d  Failure:%d",successCounter,failCounter];
    notification.soundName = NSUserNotificationDefaultSoundName;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

#pragma mark -- Deal with downloadFailMessage
-(void) getFailMessage:(NSNotification *)notification
{
    NSDictionary *userInfo=notification.userInfo;
    NSURL*filePath=[userInfo objectForKey:@"filePath"];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"self.fileURL= %@",filePath];
    NSArray *result=[fileListArray filteredArrayUsingPredicate:pred];
    if ([result count]>0) failCounter++;
    if (failCounter==[fileListArray count])
    {
        [self postTheFinishNotification];
    }
    
}


#pragma mark -- Deal with downloadFinishMessage
- (void) deleteTheCorrespondingRowAccordingTo:(NSURL *) fileURL
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"self.fileURL= %@",fileURL];
    NSArray *result=[fileListArray filteredArrayUsingPredicate:pred];
    if ([result count]>0) successCounter++;
    [fileListArray removeObject:[result lastObject]];
    [fileListView reloadData];
}

-(void)getFinishMessage:(NSNotification *)notification
{
    NSDictionary *userInfo=notification.userInfo;
    NSURL*filePath=[userInfo objectForKey:@"filePath"];
    [self deleteTheCorrespondingRowAccordingTo:filePath];
    
    if ([fileListArray count]==0)
    {
        [self postTheFinishNotification];
    }
}


#pragma mark -- Add file to the fileListArray
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
    NSIndexSet * selectedRows=[fileListView selectedRowIndexes];
	if ([selectedRows count]>0)
	{
		[fileListArray removeObjectsAtIndexes:selectedRows];
		[fileListView deselectAll:nil];
		[fileListView reloadData];
	}
	
}

- (IBAction)downloadAll:(id)sender {
    if ([fileListArray count] > 0) {
        failCounter=0;
        successCounter=0;
        for (id file in fileListArray) {
            shooter *task = [[shooter alloc] init];
            
            // Prepare and start to downloading.
            [task subDownloader:[file fileURL]];
            
        }
        
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
