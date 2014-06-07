//
//  SZFileListController.h
//  ShooterSubX
//
//  Created by Song Zhou on 6/1/14.
//  Copyright (c) 2014 SongZhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZFileListController : NSObject <NSTableViewDataSource> {
    NSMutableArray *fileListArray;
    IBOutlet NSTableView *fileListView;
}

- (IBAction)remove:(id)sender;
- (IBAction)downloadAll:(id)sender;
- (IBAction)openHelper:(id)sender;

- (void)fileStuff:(NSArray *)files;

@end
