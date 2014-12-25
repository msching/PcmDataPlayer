//
//  ViewController.m
//  PcmDataPlayer
//
//  Created by Chengyin on 14-12-25.
//  Copyright (c) 2014年 Chengyin. All rights reserved.
//

#import "ViewController.h"
#import "AVAudioPlayer+PCM.h"

@interface ViewController ()
{
@private
    AVAudioPlayer *_player;
}
@property (nonatomic,strong) IBOutlet UIButton *playButton;
@property (nonatomic,strong) IBOutlet UIButton *pauseButton;
@end

@implementation ViewController

- (AudioStreamBasicDescription)format
{
    AudioStreamBasicDescription format;
    format.mFormatID = kAudioFormatLinearPCM;
    format.mSampleRate = 44100;
    
    format.mBitsPerChannel = 16;
    format.mChannelsPerFrame = 2;
    format.mBytesPerFrame = format.mChannelsPerFrame * (format.mBitsPerChannel / 8);
    
    format.mFramesPerPacket = 1;
    format.mBytesPerPacket = format.mFramesPerPacket * format.mBytesPerFrame;
    
    format.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
    
    return format;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *pcmFilePath = [[NSBundle mainBundle] pathForResource:@"pcmData" ofType:nil];
    NSData *pcmData = [NSData dataWithContentsOfFile:pcmFilePath];
    
    NSError *error = nil;
    _player = [[AVAudioPlayer alloc] initWithPcmData:pcmData pcmFormat:[self format] error:&error];
    _player.numberOfLoops = -1;
    [_player play];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGRect frame = self.playButton.frame;
    frame.origin.x = (self.view.bounds.size.width - self.playButton.bounds.size.width) / 2;
    self.playButton.frame = frame;

    frame = self.pauseButton.frame;
    frame.origin.x = self.playButton.frame.origin.x;
    self.pauseButton.frame = frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playButtonClicked:(id)sender
{
    [_player play];
}

- (IBAction)pauseButtonClicked:(id)sender
{
    [_player pause];
}
@end
