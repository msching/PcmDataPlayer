//
//  DragView.m
//  PcmDataPlayer
//
//  Created by Chengyin on 15/12/21.
//  Copyright © 2015年 Chengyin. All rights reserved.
//

#import "DragView.h"

@implementation DragView

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self registerForDraggedTypes:@[NSFilenamesPboardType]];
    }
    return self;
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    NSMutableArray* draggedFiles = [[[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType] mutableCopy];
    if (draggedFiles.count > 0)
    {
        return NSDragOperationCopy;
    }
    return NSDragOperationNone;
}

- (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender
{
    return YES;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
    NSMutableArray* draggedFiles = [[[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType] mutableCopy];
    if (draggedFiles.count > 0)
    {
        [self draggingExited:nil];
        [_delegate dragView:self receivedFile:draggedFiles[0]];
        return YES;
    }
    return NO;
}

#pragma mark - paste
- (BOOL)performKeyEquivalent:(NSEvent *)theEvent
{
    NSString * chars = [theEvent characters];
    BOOL status = NO;
    if ([theEvent modifierFlags] & NSCommandKeyMask)
    {
        if ([chars isEqualTo:@"v"])
        {
            [self paste];
            status = YES;
        }
    }
    
    if (status)
    {
        return YES;
    }
    
    return [super performKeyEquivalent:theEvent];
}

- (void)paste
{
    id item = [[self class] lastestPasteBoardItem];
    if ([item isKindOfClass:[NSURL class]])
    {
        NSURL *url = item;
        if ([url isFileURL])
        {
            [_delegate dragView:self receivedFile:[url path]];
        }
    }
}

+ (id)lastestPasteBoardItem
{
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    NSArray *classes = [[NSArray alloc] initWithObjects:[NSURL class], [NSImage class],nil];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSPasteboardURLReadingFileURLsOnlyKey,nil];
    NSArray *copiedItems = [pasteboard readObjectsForClasses:classes options:options];
    if (copiedItems.count > 0)
    {
        id item = [copiedItems lastObject];
        if ([item isKindOfClass:[NSURL class]])
        {
            NSURL *url = item;
            if ([url isFileURL])
            {
                item = [NSURL fileURLWithPath:[url path]];
            }
        }
        return item;
    }
    return nil;
}
@end
