//
// Copyright © 2024 Stephen F. Booth <me@sbooth.org>
// Part of https://github.com/sbooth/AVFAudioExtensions
// MIT license
//

@import AudioToolbox.AudioFormat;

#import "AVAudioChannelLayout+SFBLayoutEquivalence.h"

@implementation AVAudioChannelLayout (SFBLayoutEquivalence)

- (BOOL)isEquivalentToLayout:(AVAudioChannelLayout *)channelLayout
{
	if(!channelLayout) {
		AudioChannelLayoutTag layoutTag = self.layoutTag;
		return layoutTag == kAudioChannelLayoutTag_Mono || layoutTag == kAudioChannelLayoutTag_Stereo;
	}

	const AudioChannelLayout *layouts [] = {
		self.layout,
		channelLayout.layout
	};

	UInt32 layoutsEqual = 0;
	UInt32 propertySize = sizeof(layoutsEqual);
	OSStatus result = AudioFormatGetProperty(kAudioFormatProperty_AreChannelLayoutsEquivalent, sizeof(layouts), layouts, &propertySize, &layoutsEqual);
	if(noErr != result)
		return false;

	return layoutsEqual;
}

@end
