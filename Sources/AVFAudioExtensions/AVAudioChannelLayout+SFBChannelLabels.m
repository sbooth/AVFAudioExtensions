//
// SPDX-FileCopyrightText: 2013 Stephen F. Booth <contact@sbooth.dev>
// SPDX-License-Identifier: MIT
//
// Part of https://github.com/sbooth/AVFAudioExtensions
//

#import "AVFAudioExtensions/AVAudioChannelLayout+SFBChannelLabels.h"

#import <AudioToolbox/AudioFormat.h>

#import <stdlib.h>
#import <string.h>

static size_t GetChannelLayoutSize(UInt32 numberChannelDescriptions) {
    return offsetof(AudioChannelLayout, mChannelDescriptions) +
           (numberChannelDescriptions * sizeof(AudioChannelDescription));
}

static AudioChannelLayout *CreateChannelLayout(UInt32 numberChannelDescriptions) {
    size_t layoutSize = GetChannelLayoutSize(numberChannelDescriptions);
    AudioChannelLayout *channelLayout = malloc(layoutSize);
    if (!channelLayout) {
        return NULL;
    }

    memset(channelLayout, 0, layoutSize);

    return channelLayout;
}

static AudioChannelLabel ChannelLabelForString(NSString *s) {
    static NSDictionary *labels = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        labels = @{
            @"l" : @(kAudioChannelLabel_Left),
            @"r" : @(kAudioChannelLabel_Right),
            @"c" : @(kAudioChannelLabel_Center),
            @"lfe" : @(kAudioChannelLabel_LFEScreen),
            @"ls" : @(kAudioChannelLabel_LeftSurround),
            @"rs" : @(kAudioChannelLabel_RightSurround),
            @"lc" : @(kAudioChannelLabel_LeftCenter),
            @"rc" : @(kAudioChannelLabel_RightCenter),
            @"cs" : @(kAudioChannelLabel_CenterSurround),
            @"lsd" : @(kAudioChannelLabel_LeftSurroundDirect),
            @"rsd" : @(kAudioChannelLabel_RightSurroundDirect),
            @"tcs" : @(kAudioChannelLabel_TopCenterSurround),
            @"vhl" : @(kAudioChannelLabel_VerticalHeightLeft),
            @"vhc" : @(kAudioChannelLabel_VerticalHeightCenter),
            @"vhr" : @(kAudioChannelLabel_VerticalHeightRight),

            @"tbl" : @(kAudioChannelLabel_TopBackLeft),
            @"tbc" : @(kAudioChannelLabel_TopBackCenter),
            @"tbr" : @(kAudioChannelLabel_TopBackRight),

            @"rls" : @(kAudioChannelLabel_RearSurroundLeft),
            @"rrs" : @(kAudioChannelLabel_RearSurroundRight),

            @"lw" : @(kAudioChannelLabel_LeftWide),
            @"rw" : @(kAudioChannelLabel_RightWide),
        };
    });

    NSNumber *label = [labels objectForKey:s];
    if (label != nil) {
        return (AudioChannelLabel)label.unsignedIntValue;
    }
    return kAudioChannelLabel_Unknown;
}

@implementation AVAudioChannelLayout (SFBChannelLabels)

+ (nullable instancetype)layoutWithChannelLabels:(AVAudioChannelCount)count, ... {
    va_list ap;
    va_start(ap, count);

    AVAudioChannelLayout *layout = [[AVAudioChannelLayout alloc] initWithChannelLabels:count ap:ap];

    va_end(ap);

    return layout;
}

+ (nullable instancetype)layoutWithChannelLabels:(const AudioChannelLabel *)channelLabels
                                           count:(AVAudioChannelCount)count {
    return [[AVAudioChannelLayout alloc] initWithChannelLabels:channelLabels count:count];
}

+ (instancetype)layoutWithChannelLabelString:(NSString *)channelLabelString {
    return [[AVAudioChannelLayout alloc] initWithChannelLabelString:channelLabelString];
}

- (nullable instancetype)initWithChannelLabels:(AVAudioChannelCount)count, ... {
    va_list ap;
    va_start(ap, count);

    self = [self initWithChannelLabels:count ap:ap];

    va_end(ap);

    return self;
}

- (nullable instancetype)initWithChannelLabels:(AVAudioChannelCount)count ap:(va_list)ap {
    NSParameterAssert(count > 0);
    NSParameterAssert(ap != NULL);

    AudioChannelLabel *channelLabels = malloc(sizeof(AudioChannelLabel) * count);
    if (!channelLabels) {
        return nil;
    }

    for (AVAudioChannelCount i = 0; i < count; ++i) {
        channelLabels[i] = va_arg(ap, AudioChannelLabel);
    }

    self = [self initWithChannelLabels:channelLabels count:count];
    free(channelLabels);
    return self;
}

- (nullable instancetype)initWithChannelLabels:(const AudioChannelLabel *)channelLabels
                                         count:(AVAudioChannelCount)count {
    NSParameterAssert(channelLabels != NULL);
    NSParameterAssert(count > 0);

    AudioChannelLayout *channelLayout = CreateChannelLayout(count);
    if (!channelLayout) {
        return nil;
    }

    channelLayout->mChannelLayoutTag = kAudioChannelLayoutTag_UseChannelDescriptions;
    channelLayout->mNumberChannelDescriptions = count;

    for (AVAudioChannelCount i = 0; i < count; ++i) {
        channelLayout->mChannelDescriptions[i].mChannelLabel = channelLabels[i];
    }

    // Attempt to convert the channel labels to a layout tag
    AudioChannelLayoutTag tag;
    UInt32 dataSize = sizeof(tag);
    OSStatus result = AudioFormatGetProperty(kAudioFormatProperty_TagForChannelLayout,
                                             (UInt32)GetChannelLayoutSize(count), channelLayout, &dataSize, &tag);
    if (result == noErr) {
        self = [self initWithLayoutTag:tag];
    } else {
        self = [self initWithLayout:channelLayout];
    }

    free(channelLayout);

    return self;
}

- (nullable instancetype)initWithChannelLabelString:(NSString *)channelLabelString {
    NSParameterAssert(channelLabelString != nil);

    NSArray *channelLabelArray = [[channelLabelString lowercaseString] componentsSeparatedByString:@" "];

    NSUInteger count = channelLabelArray.count;

    AudioChannelLabel *channelLabels = malloc(sizeof(AudioChannelLabel) * count);
    if (!channelLabels) {
        return nil;
    }

    for (NSUInteger i = 0; i < count; ++i) {
        channelLabels[i] = ChannelLabelForString([channelLabelArray objectAtIndex:i]);
    }

    self = [self initWithChannelLabels:channelLabels count:(AVAudioChannelCount)count];
    free(channelLabels);
    return self;
}

@end
