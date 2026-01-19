//
// SPDX-FileCopyrightText: 2024 Stephen F. Booth <contact@sbooth.dev>
// SPDX-License-Identifier: MIT
//
// Part of https://github.com/sbooth/AVFAudioExtensions
//

#import <AVFAudio/AVFAudio.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Functions for getting audio format names
@interface AVAudioFormat (SFBFormatName)

/// Returns the name of the audio format.
/// - note: This is the value returned by `kAudioFormatProperty_FormatName`
@property(nonatomic, readonly) NSString *formatName;

@end

NS_ASSUME_NONNULL_END
