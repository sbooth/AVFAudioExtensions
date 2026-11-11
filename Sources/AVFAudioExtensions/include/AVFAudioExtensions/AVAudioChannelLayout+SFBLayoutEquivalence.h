//
// SPDX-FileCopyrightText: 2024 Stephen F. Booth <contact@sbooth.dev>
// SPDX-License-Identifier: MIT
//
// Part of https://github.com/sbooth/AVFAudioExtensions
//

#import <AVFAudio/AVFAudio.h>

NS_ASSUME_NONNULL_BEGIN

/// Functions for testing channel layout equivalence
@interface AVAudioChannelLayout (SFBLayoutEquivalence)

/// Returns `YES` if `self` is equivalent to `channelLayout`
///
/// Channel layouts are considered equivalent if:
/// 1) `channelLayout` is `nil` and `self` has a mono or stereo layout tag
/// 2) `kAudioFormatProperty_AreChannelLayoutsEquivalent` is true
/// - parameter channelLayout: An `AVAudioChannelLayout` object to compare to `self`
/// - returns: `YES` if `self` and `channelLayout` are equivalent
- (BOOL)isEquivalentToLayout:(nullable AVAudioChannelLayout *)channelLayout;

@end

NS_ASSUME_NONNULL_END
