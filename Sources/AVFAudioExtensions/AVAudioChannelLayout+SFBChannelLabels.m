//
// Copyright © 2013-2024 Stephen F. Booth <me@sbooth.org>
// Part of https://github.com/sbooth/AVFAudioExtensions
// MIT license
//

#import <stdlib.h>
#import <string.h>

#import "AVAudioChannelLayout+SFBChannelLabels.h"

static size_t GetChannelLayoutSize(UInt32 numberChannelDescriptions)
{
	return offsetof(AudioChannelLayout, mChannelDescriptions) + (numberChannelDescriptions * sizeof(AudioChannelDescription));
}

static AudioChannelLayout * CreateChannelLayout(UInt32 numberChannelDescriptions)
{
	size_t layoutSize = GetChannelLayoutSize(numberChannelDescriptions);
	AudioChannelLayout *channelLayout = (AudioChannelLayout *)malloc(layoutSize);
	if(!channelLayout)
		return NULL;

	memset(channelLayout, 0, layoutSize);

	return channelLayout;
}

static AudioChannelLabel ChannelLabelForString(NSString *s)
{
	static NSDictionary *labels = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		labels = @{
			@"l"	: @(kAudioChannelLabel_Left),
			@"r"	: @(kAudioChannelLabel_Right),
			@"c"	: @(kAudioChannelLabel_Center),
			@"lfe"	: @(kAudioChannelLabel_LFEScreen),
			@"ls"	: @(kAudioChannelLabel_LeftSurround),
			@"rs"	: @(kAudioChannelLabel_RightSurround),
			@"lc"	: @(kAudioChannelLabel_LeftCenter),
			@"rc"	: @(kAudioChannelLabel_RightCenter),
			@"cs"	: @(kAudioChannelLabel_CenterSurround),
			@"lsd"	: @(kAudioChannelLabel_LeftSurroundDirect),
			@"rsd"	: @(kAudioChannelLabel_RightSurroundDirect),
			@"tcs"	: @(kAudioChannelLabel_TopCenterSurround),
			@"vhl"	: @(kAudioChannelLabel_VerticalHeightLeft),
			@"vhc"	: @(kAudioChannelLabel_VerticalHeightCenter),
			@"vhr"	: @(kAudioChannelLabel_VerticalHeightRight),

			@"tbl"	: @(kAudioChannelLabel_TopBackLeft),
			@"tbc"	: @(kAudioChannelLabel_TopBackCenter),
			@"tbr"	: @(kAudioChannelLabel_TopBackRight),

			@"rls"	: @(kAudioChannelLabel_RearSurroundLeft),
			@"rrs"	: @(kAudioChannelLabel_RearSurroundRight),

			@"lw"	: @(kAudioChannelLabel_LeftWide),
			@"rw"	: @(kAudioChannelLabel_RightWide),
		};
	});

	NSNumber *label = [labels objectForKey:s];
	if(label != nil)
		return (AudioChannelLabel)label.unsignedIntValue;
	return kAudioChannelLabel_Unknown;
}

@implementation AVAudioChannelLayout (SFBChannelLabels)

+ (instancetype)layoutWithChannelLabels:(AVAudioChannelCount)count, ...
{
	va_list ap;
	va_start(ap, count);

	AVAudioChannelLayout *layout = [[AVAudioChannelLayout alloc] initWithChannelLabels:count ap:ap];

	va_end(ap);

	return layout;
}

+ (instancetype)layoutWithChannelLabels:(const AudioChannelLabel *)channelLabels count:(AVAudioChannelCount)count
{
	return [[AVAudioChannelLayout alloc] initWithChannelLabels:channelLabels count:count];
}

+ (instancetype)layoutWithChannelLabelString:(NSString *)channelLabelString
{
	return [[AVAudioChannelLayout alloc] initWithChannelLabelString:channelLabelString];
}

- (instancetype)initWithChannelLabels:(AVAudioChannelCount)count, ...
{
	va_list ap;
	va_start(ap, count);

	self = [self initWithChannelLabels:count ap:ap];

	va_end(ap);

	return self;
}

- (instancetype)initWithChannelLabels:(AVAudioChannelCount)count ap:(va_list)ap
{
	NSParameterAssert(count > 0);
	NSParameterAssert(ap != NULL);

	AudioChannelLayout *channelLayout = CreateChannelLayout(count);
	if(!channelLayout)
		return nil;

	channelLayout->mChannelLayoutTag = kAudioChannelLayoutTag_UseChannelDescriptions;
	channelLayout->mNumberChannelDescriptions = count;

	for(AVAudioChannelCount i = 0; i < count; ++i)
		channelLayout->mChannelDescriptions[i].mChannelLabel = va_arg(ap, AudioChannelLabel);

	self = [self initWithLayout:channelLayout];
	free(channelLayout);
	return self;
}

- (instancetype)initWithChannelLabels:(const AudioChannelLabel *)channelLabels count:(AVAudioChannelCount)count
{
	NSParameterAssert(channelLabels != NULL);
	NSParameterAssert(count > 0);

	AudioChannelLayout *channelLayout = CreateChannelLayout(count);
	if(!channelLayout)
		return nil;

	channelLayout->mChannelLayoutTag = kAudioChannelLayoutTag_UseChannelDescriptions;
	channelLayout->mNumberChannelDescriptions = count;

	for(AVAudioChannelCount i = 0; i < count; ++i)
		channelLayout->mChannelDescriptions[i].mChannelLabel = channelLabels[i];

	self = [self initWithLayout:channelLayout];
	free(channelLayout);
	return self;
}

- (instancetype)initWithChannelLabelString:(NSString *)channelLabelString
{
	NSParameterAssert(channelLabelString != nil);

	NSArray *channelLabels = [[channelLabelString lowercaseString] componentsSeparatedByString:@" "];

	AVAudioChannelCount count = (AVAudioChannelCount)channelLabels.count;
	AudioChannelLayout *channelLayout = CreateChannelLayout(count);
	if(!channelLayout)
		return nil;

	channelLayout->mChannelLayoutTag = kAudioChannelLayoutTag_UseChannelDescriptions;
	channelLayout->mNumberChannelDescriptions = count;

	for(AVAudioChannelCount i = 0; i < count; ++i)
		channelLayout->mChannelDescriptions[i].mChannelLabel = ChannelLabelForString([channelLabels objectAtIndex:i]);

	self = [self initWithLayout:channelLayout];
	free(channelLayout);
	return self;
}

@end
