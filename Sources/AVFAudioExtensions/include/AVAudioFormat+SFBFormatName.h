//
// Copyright © 2024 Stephen F. Booth <me@sbooth.org>
// Part of https://github.com/sbooth/AVFAudioExtensions
// MIT license
//

#import <AVFAudio/AVFAudio.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AVAudioFormat (SFBFormatName)

/// Returns the format's name.
/// - note: This is the value returned by `kAudioFormatProperty_FormatName`
@property (nonatomic, readonly) NSString * formatName;

/// Returns a detailed description of the format.
@property (nonatomic, readonly) NSString * formatDetailedDescription;

@end

NS_ASSUME_NONNULL_END
