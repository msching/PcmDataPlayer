//
//  Window.m
//  PcmDataPlayer
//
//  Created by Chengyin on 15/12/21.
//  Copyright © 2015年 Chengyin. All rights reserved.
//

#import "Window.h"
#import "AVAudioPlayer+Sample.h"
#import "NSTimer+BlocksSupport.h"
#import "DragView.h"

@interface Window ()<DragViewDelegate>
{
@private
    AVAudioPlayer *_player;
    NSTimer *_timer;
    NSString *_path;
    DragView *_dragView;
}
@property (nonatomic,strong) IBOutlet NSButton *playOrPauseButton;
@property (nonatomic,strong) IBOutlet NSSlider *progressSlider;
@property (nonatomic,strong) IBOutlet NSTextField *label;
@property (nonatomic,strong) NSString *path;
@end

@implementation Window

- (void)dragView:(DragView *)dragView receivedFile:(NSString *)file
{
    [self createPlayer:file];
    [self play];
}

- (void)awakeFromNib
{
    _dragView = [[DragView alloc] initWithFrame:NSMakeRect(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    _dragView.delegate = self;
    [self.contentView addSubview:_dragView];
    
    [self createPlayer:[[NSBundle mainBundle] pathForResource:@"pcmData" ofType:nil]];
}

- (void)setFrame:(NSRect)frameRect display:(BOOL)flag
{
    [super setFrame:frameRect display:flag];
    _dragView.frame = NSMakeRect(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
}

- (void)createPlayer:(NSString *)path
{
    self.path = path;
    _player = [AVAudioPlayer sp_createPlayer:_path];
}

- (void)play
{
    [_player play];
    [self handleStatusChanged];
}

- (void)pause
{
    [_player pause];
    [self handleStatusChanged];
}

- (void)stop
{
    [_player stop];
    _player.currentTime = 0;
    [self handleStatusChanged];
    [self progressMove];
}

- (void)handleStatusChanged
{
    if (_player.playing)
    {
        [self.playOrPauseButton setTitle:@"Pause"];
        [self startTimer];
        
    }
    else
    {
        [self.playOrPauseButton setTitle:@"Play"];
        [self stopTimer];
        [self progressMove];
    }
}

- (void)setPath:(NSString *)path
{
    _path = path;
    [_label setStringValue:_path];
}

#pragma mark - timer
- (void)startTimer
{
    if (!_timer)
    {
        __weak typeof(self)weakSelf = self;
        _timer = [NSTimer bs_scheduledTimerWithTimeInterval:1 block:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf progressMove];
            [strongSelf handleStatusChanged];
        } repeats:YES];
        [_timer fire];
    }
}

- (void)stopTimer
{
    if (_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)progressMove
{
    if (!self.progressSlider.isHighlighted)
    {
        if (_player.duration != 0)
        {
            self.progressSlider.doubleValue = _player.currentTime / _player.duration;
        }
        else
        {
            self.progressSlider.doubleValue = 0;
        }
    }
}

#pragma mark - action
- (IBAction)playOrPause:(id)sender
{
    if (_player.playing)
    {
        [self pause];
    }
    else
    {
        [self play];
    }
}

- (IBAction)stop:(id)sender
{
    [self stop];
}

- (IBAction)seek:(id)sender
{
    _player.currentTime = _player.duration * self.progressSlider.doubleValue;
}
@end
