//
// SPDX-FileCopyrightText: 2024 Stephen F. Booth <contact@sbooth.dev>
// SPDX-License-Identifier: MIT
//
// Part of https://github.com/sbooth/AVFAudioExtensions
//

#import "AVAudioFormat+SFBFormatName.h"

#import <AudioToolbox/AudioFormat.h>

#import <stdint.h>

@implementation AVAudioFormat (SFBFormatName)

- (NSString *)formatName {
    CFStringRef name = NULL;
    UInt32 dataSize = sizeof(name);
    OSStatus result = AudioFormatGetProperty(kAudioFormatProperty_FormatName, sizeof(AudioStreamBasicDescription),
                                             self.streamDescription, &dataSize, &name);
    if (result != noErr || name == NULL) {
        return @"";
    }
    return (__bridge_transfer NSString *)name;
}

@end
