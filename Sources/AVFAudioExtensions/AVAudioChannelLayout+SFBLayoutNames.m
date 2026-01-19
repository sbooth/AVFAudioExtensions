//
// SPDX-FileCopyrightText: 2024 Stephen F. Booth <contact@sbooth.dev>
// SPDX-License-Identifier: MIT
//
// Part of https://github.com/sbooth/AVFAudioExtensions
//

#import "AVAudioChannelLayout+SFBLayoutNames.h"

#import <AudioToolbox/AudioFormat.h>

static NSString *GetLayoutName(const AudioChannelLayout *layout, BOOL simpleName) {
    NSCParameterAssert(layout != NULL);

    AudioFormatPropertyID property =
          simpleName ? kAudioFormatProperty_ChannelLayoutSimpleName : kAudioFormatProperty_ChannelLayoutName;
    UInt32 layoutSize = offsetof(AudioChannelLayout, mChannelDescriptions) +
                        (layout->mNumberChannelDescriptions * sizeof(AudioChannelDescription));
    CFStringRef name = NULL;
    UInt32 dataSize = sizeof(name);
    OSStatus result = AudioFormatGetProperty(property, layoutSize, layout, &dataSize, &name);
    if (result != noErr || name == NULL)
        return @"";
    return (__bridge_transfer NSString *)name;
}

@implementation AVAudioChannelLayout (SFBLayoutNames)

- (NSString *)layoutName {
    return GetLayoutName(self.layout, NO);
}

- (NSString *)layoutSimpleName {
    return GetLayoutName(self.layout, YES);
}

@end
