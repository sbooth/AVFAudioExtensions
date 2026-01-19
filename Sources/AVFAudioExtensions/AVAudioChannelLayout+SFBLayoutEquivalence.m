//
// SPDX-FileCopyrightText: 2024 Stephen F. Booth <contact@sbooth.dev>
// SPDX-License-Identifier: MIT
//
// Part of https://github.com/sbooth/AVFAudioExtensions
//

#import "AVAudioChannelLayout+SFBLayoutEquivalence.h"

@import AudioToolbox.AudioFormat;

@implementation AVAudioChannelLayout (SFBLayoutEquivalence)

- (BOOL)isEquivalentToLayout:(AVAudioChannelLayout *)channelLayout {
    if (!channelLayout) {
        AudioChannelLayoutTag layoutTag = self.layoutTag;
        return layoutTag == kAudioChannelLayoutTag_Mono || layoutTag == kAudioChannelLayoutTag_Stereo;
    }

    const AudioChannelLayout *layouts[] = {self.layout, channelLayout.layout};

    UInt32 layoutsEqual = 0;
    UInt32 propertySize = sizeof(layoutsEqual);
    OSStatus result = AudioFormatGetProperty(kAudioFormatProperty_AreChannelLayoutsEquivalent, sizeof(layouts), layouts,
                                             &propertySize, &layoutsEqual);
    if (noErr != result)
        return NO;

    return layoutsEqual;
}

@end
