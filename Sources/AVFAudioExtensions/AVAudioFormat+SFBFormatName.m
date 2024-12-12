//
// Copyright © 2024 Stephen F. Booth <me@sbooth.org>
// Part of https://github.com/sbooth/AVFAudioExtensions
// MIT license
//

@import AudioToolbox.AudioFormat;

#import "AVAudioFormat+SFBFormatName.h"

@implementation AVAudioFormat (SFBFormatName)

- (NSString *)formatName
{
	CFStringRef name = NULL;
	UInt32 dataSize = sizeof(name);
	OSStatus result = AudioFormatGetProperty(kAudioFormatProperty_FormatName, sizeof(AudioStreamBasicDescription), self.streamDescription, &dataSize, &name);
	if(result != noErr || name == NULL)
		return @"";
	return (__bridge_transfer NSString *)name;
}

@end
