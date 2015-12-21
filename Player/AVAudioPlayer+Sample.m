//
//  AVAudioPlayer+Sample.m
//  PcmDataPlayer
//
//  Created by Chengyin on 15/12/21.
//  Copyright © 2015年 Chengyin. All rights reserved.
//

#import "AVAudioPlayer+Sample.h"
#import "AVAudioPlayer+PCM.h"

@implementation AVAudioPlayer (Sample)
+ (AudioStreamBasicDescription)sp_format
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

+ (instancetype)sp_createPlayer:(NSString *)path
{
    NSData *pcmData = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithPcmData:pcmData pcmFormat:[self sp_format] error:&error];
    player.numberOfLoops = -1;
    return player;
}
@end
