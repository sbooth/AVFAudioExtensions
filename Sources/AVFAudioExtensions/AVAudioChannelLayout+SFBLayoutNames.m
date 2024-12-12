//
// Copyright © 2024 Stephen F. Booth <me@sbooth.org>
// Part of https://github.com/sbooth/AVFAudioExtensions
// MIT license
//

#import <AudioToolbox/AudioFormat.h>

#import "AVAudioChannelLayout+SFBLayoutNames.h"

static NSString * GetLayoutName(const AudioChannelLayout *layout, BOOL simpleName)
{
	if(!layout)
		return nil;
	AudioFormatPropertyID property = simpleName ? kAudioFormatProperty_ChannelLayoutSimpleName : kAudioFormatProperty_ChannelLayoutName;
	UInt32 layoutSize = offsetof(AudioChannelLayout, mChannelDescriptions) + (layout->mNumberChannelDescriptions * sizeof(AudioChannelDescription));
	CFStringRef name = NULL;
	UInt32 dataSize = sizeof(name);
	OSStatus result = AudioFormatGetProperty(property, layoutSize, layout, &dataSize, &name);
	if(result != noErr)
		return nil;
	return (__bridge_transfer NSString *)name;
}

@implementation AVAudioChannelLayout (SFBLayoutNames)

- (NSString *)layoutName
{
	return GetLayoutName(self.layout, NO);
}

- (NSString *)layoutSimpleName
{
	return GetLayoutName(self.layout, YES);
}

@end
