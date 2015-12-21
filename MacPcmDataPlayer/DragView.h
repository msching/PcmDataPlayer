//
//  DragView.h
//  PcmDataPlayer
//
//  Created by Chengyin on 15/12/21.
//  Copyright © 2015年 Chengyin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DragView;
@protocol DragViewDelegate <NSObject>
- (void)dragView:(DragView *)dragView receivedFile:(NSString *)file;
@end

@interface DragView : NSView
@property (nonatomic,weak) id<DragViewDelegate> delegate;
@end
