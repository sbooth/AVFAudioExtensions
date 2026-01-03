//
// SPDX-FileCopyrightText: 2020 Stephen F. Booth <contact@sbooth.dev>
// SPDX-License-Identifier: MIT
//
// Part of https://github.com/sbooth/AVFAudioExtensions
//

#import <AVFAudio/AVFAudio.h>

NS_ASSUME_NONNULL_BEGIN

@interface AVAudioFormat (SFBFormatTransformation)
/// Returns a copy of `self` converted to the equivalent non-interleaved format
/// - note: Returns `nil` for non-PCM formats
- (nullable AVAudioFormat *)nonInterleavedEquivalent;
/// Returns a copy of `self` converted to the equivalent interleaved format
/// - note: Returns `nil` for non-PCM formats
- (nullable AVAudioFormat *)interleavedEquivalent;
/// Returns a copy of `self` converted to the equivalent standard format
- (nullable AVAudioFormat *)standardEquivalent;
/// Returns the specified common format with the same sample rate and channel layout as `self`
- (nullable AVAudioFormat *)transformedToCommonFormat:(AVAudioCommonFormat)commonFormat interleaved:(BOOL)interleaved;
@end

NS_ASSUME_NONNULL_END
