//
//  SZTableViewDropperView.m
//  ShooterSubX
//
//  Created by Song Zhou on 6/1/14.
//  Copyright (c) 2014 SongZhou. All rights reserved.
//

#import "SZTableViewDropperView.h"

@implementation SZTableViewDropperView {
    BOOL highlight;
}

- (void)awakeFromNib {
    [self registerForDraggedTypes:@[NSFilenamesPboardType]];
}

// Stop the NSTableView implementation geeting in the way.
- (NSDragOperation)draggingUpdated:(id<NSDraggingInfo>)sender {
    return [self draggingEntered:sender];
}

#pragma GCC diagnostic ignored "-Wundeclared-selector"
- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
    NSLog(@"performDragOperation in SZTableViewDropper.h");
    
    NSPasteboard *pboard = [sender draggingPasteboard];
    NSArray *filenames = [pboard propertyListForType:NSFilenamesPboardType];
    
    id delegate = [self delegate];
    
    if ([delegate respondsToSelector:@selector(fileStuff:)]) {
        [delegate performSelector:@selector (fileStuff:) withObject:filenames];
    }
    
    highlight = NO;
    [self setNeedsDisplay: YES];
    
    return YES;
}

- (BOOL)prepareForDragOperation:(id)sender {
    NSLog(@"prepareForDragOperation called in TableViewDropper.h");
    return YES;
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    if (highlight == NO) {
        NSLog(@"drag enterd in SZTableViewDropper.h");
        highlight = YES;
        [self setNeedsDisplay: YES];
    }
    
    return NSDragOperationCopy;
}

- (void)draggingExited:(id)sender {
    highlight = NO;
    
    [self setNeedsDisplay: YES];
    NSLog(@"drag exit in SZTableViewDropper.h");
}
- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    if (highlight) {
        // highlight by oberlaying a gray border.
        [[NSColor colorWithCalibratedRed:0.226 green:0.6041 blue:0.8 alpha:0.5] set];
        [NSBezierPath setDefaultLineWidth: 6];
        [NSBezierPath strokeRect: dirtyRect];
    }
}

@end
