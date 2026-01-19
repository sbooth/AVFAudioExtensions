//
// SPDX-FileCopyrightText: 2024 Stephen F. Booth <contact@sbooth.dev>
// SPDX-License-Identifier: MIT
//
// Part of https://github.com/sbooth/AVFAudioExtensions
//

#import <AVFAudio/AVFAudio.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Functions for getting channel layout names
@interface AVAudioChannelLayout (SFBLayoutNames)

/// Returns the name of the channel layout.
/// - note: This is the value returned by `kAudioFormatProperty_ChannelLayoutName`
@property(nonatomic, readonly) NSString *layoutName;

/// Returns the name of the channel layout without channel labels.
/// - note: This is the value returned by `kAudioFormatProperty_ChannelLayoutSimpleName`
@property(nonatomic, readonly) NSString *layoutSimpleName;

@end

NS_ASSUME_NONNULL_END
