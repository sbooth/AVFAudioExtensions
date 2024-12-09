//
// Copyright © 2024 Stephen F. Booth <me@sbooth.org>
// Part of https://github.com/sbooth/AVFAudioExtensions
// MIT license
//

#import <AVFAudio/AVFAudio.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Functions for getting the channel layout's name
@interface AVAudioChannelLayout (SFBLayoutNames)

/// Returns the channel layout name.
/// - note: This is the value returned by `kAudioFormatProperty_ChannelLayoutName`
@property (nonatomic, readonly) NSString * layoutName;

/// Returns the channel layout's simple name.
/// - note: This is the value returned by `kAudioFormatProperty_ChannelLayoutSimpleName`
@property (nonatomic, readonly) NSString * layoutSimpleName;

@end

NS_ASSUME_NONNULL_END
