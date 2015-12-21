//
//  AVAudioPlayer+Sample.h
//  PcmDataPlayer
//
//  Created by Chengyin on 15/12/21.
//  Copyright © 2015年 Chengyin. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVAudioPlayer (Sample)
+ (instancetype)sp_createPlayer:(NSString *)path;
@end
