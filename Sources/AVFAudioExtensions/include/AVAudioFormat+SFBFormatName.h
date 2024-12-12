//
// Copyright © 2024 Stephen F. Booth <me@sbooth.org>
// Part of https://github.com/sbooth/AVFAudioExtensions
// MIT license
//

#import <AVFAudio/AVFAudio.h>
#import <Foundation/Foundation.h>

@interface AVAudioFormat (SFBFormatName)

/// Returns the format name.
/// - note: This is the value returned by `kAudioFormatProperty_FormatName`
@property (nonatomic, readonly) NSString * formatName;

@end
