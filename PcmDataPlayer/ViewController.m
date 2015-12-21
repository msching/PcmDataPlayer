//
//  ViewController.m
//  PcmDataPlayer
//
//  Created by Chengyin on 14-12-25.
//  Copyright (c) 2014年 Chengyin. All rights reserved.
//

#import "ViewController.h"
#import "AVAudioPlayer+Sample.h"
#import "NSTimer+BlocksSupport.h"

@interface ViewController ()
{
@private
    AVAudioPlayer *_player;
    NSTimer *_timer;
    NSString *_path;
}
@property (nonatomic,strong) IBOutlet UIButton *playOrPauseButton;
@property (nonatomic,strong) IBOutlet UISlider *progressSlider;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _path = [[NSBundle mainBundle] pathForResource:@"pcmData" ofType:nil];
    _player = [AVAudioPlayer sp_createPlayer:_path];
    [self play];
}


#pragma mark - player
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
        [self.playOrPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        [self startTimer];
        
    }
    else
    {
        [self.playOrPauseButton setTitle:@"Play" forState:UIControlStateNormal];
        [self stopTimer];
        [self progressMove];
    }
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
    if (!self.progressSlider.tracking)
    {
        if (_player.duration != 0)
        {
            self.progressSlider.value = _player.currentTime / _player.duration;
        }
        else
        {
            self.progressSlider.value = 0;
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
    _player.currentTime = _player.duration * self.progressSlider.value;
}
@end
