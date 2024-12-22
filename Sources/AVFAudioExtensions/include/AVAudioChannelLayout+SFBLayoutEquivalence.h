//
// Copyright © 2024 Stephen F. Booth <me@sbooth.org>
// Part of https://github.com/sbooth/AVFAudioExtensions
// MIT license
//

#import <AVFAudio/AVFAudio.h>

NS_ASSUME_NONNULL_BEGIN

/// Functions for testing channel layout equivalence
@interface AVAudioChannelLayout (SFBLayoutEquivalence)

- (BOOL)isEquivalentToLayout:(nullable AVAudioChannelLayout *)channelLayout;

@end

NS_ASSUME_NONNULL_END
