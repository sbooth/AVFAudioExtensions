//
// Copyright © 2024 Stephen F. Booth <me@sbooth.org>
// Part of https://github.com/sbooth/AVFAudioExtensions
// MIT license
//

#import <stdint.h>

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

- (NSString *)formatDetailedDescription
{
	NSMutableString *result = [[NSMutableString alloc] initWithCapacity:128];

	const AudioStreamBasicDescription *asbd = self.streamDescription;

	// General description
	if(rint(asbd->mSampleRate) == asbd->mSampleRate)
		[result appendFormat:@"%u ch, %lld Hz, ", asbd->mChannelsPerFrame, (int64_t)asbd->mSampleRate];
	else
		[result appendFormat:@"%u ch, %.2f Hz, ", asbd->mChannelsPerFrame, asbd->mSampleRate];

	// Descriptive format name
	switch(asbd->mFormatID) {
		case kAudioFormatLinearPCM: 			[result appendString:@"Linear PCM"];  											break;
		case kAudioFormatAC3: 					[result appendString:@"AC-3"];  												break;
		case kAudioFormat60958AC3: 				[result appendString:@"AC-3 over IEC 60958"];  									break;
		case kAudioFormatAppleIMA4: 			[result appendString:@"IMA 4:1 ADPCM"];  										break;
		case kAudioFormatMPEG4AAC: 				[result appendString:@"MPEG-4 Low Complexity AAC"];  							break;
		case kAudioFormatMPEG4CELP: 			[result appendString:@"MPEG-4 CELP"];  											break;
		case kAudioFormatMPEG4HVXC: 			[result appendString:@"MPEG-4 HVXC"];  											break;
		case kAudioFormatMPEG4TwinVQ: 			[result appendString:@"MPEG-4 TwinVQ"];  										break;
		case kAudioFormatMACE3: 				[result appendString:@"MACE 3:1"];  											break;
		case kAudioFormatMACE6: 				[result appendString:@"MACE 6:1"];  											break;
		case kAudioFormatULaw: 					[result appendString:@"µ-law 2:1"];  											break;
		case kAudioFormatALaw: 					[result appendString:@"A-law 2:1"];  											break;
		case kAudioFormatQDesign: 				[result appendString:@"QDesign music"];  										break;
		case kAudioFormatQDesign2: 				[result appendString:@"QDesign2 music"];  										break;
		case kAudioFormatQUALCOMM :				[result appendString:@"QUALCOMM PureVoice"];  									break;
		case kAudioFormatMPEGLayer1: 			[result appendString:@"MPEG-1/2 Layer I"];  									break;
		case kAudioFormatMPEGLayer2: 			[result appendString:@"MPEG-1/2 Layer II"];  									break;
		case kAudioFormatMPEGLayer3: 			[result appendString:@"MPEG-1/2 Layer III"];  									break;
		case kAudioFormatTimeCode: 				[result appendString:@"Stream of IOAudioTimeStamps"];  							break;
		case kAudioFormatMIDIStream: 			[result appendString:@"Stream of MIDIPacketLists"];  							break;
		case kAudioFormatParameterValueStream: 	[result appendString:@"Float32 side-chain"];  									break;
		case kAudioFormatAppleLossless: 		[result appendString:@"Apple Lossless"];  										break;
		case kAudioFormatMPEG4AAC_HE: 			[result appendString:@"MPEG-4 High Efficiency AAC"];  							break;
		case kAudioFormatMPEG4AAC_LD: 			[result appendString:@"MPEG-4 AAC Low Delay"];  								break;
		case kAudioFormatMPEG4AAC_ELD: 			[result appendString:@"MPEG-4 AAC Enhanced Low Delay"];  						break;
		case kAudioFormatMPEG4AAC_ELD_SBR: 		[result appendString:@"MPEG-4 AAC Enhanced Low Delay with SBR extension"];  	break;
		case kAudioFormatMPEG4AAC_ELD_V2: 		[result appendString:@"MPEG-4 AAC Enhanced Low Delay Version 2"];  				break;
		case kAudioFormatMPEG4AAC_HE_V2: 		[result appendString:@"MPEG-4 High Efficiency AAC Version 2"];  				break;
		case kAudioFormatMPEG4AAC_Spatial: 		[result appendString:@"MPEG-4 Spatial Audio"];  								break;
		case kAudioFormatMPEGD_USAC: 			[result appendString:@"MPEG-D Unified Speech and Audio Coding"];  				break;
		case kAudioFormatAMR: 					[result appendString:@"AMR Narrow Band"];  										break;
		case kAudioFormatAMR_WB: 				[result appendString:@"AMR Wide Band"];  										break;
		case kAudioFormatAudible: 				[result appendString:@"Audible"];  												break;
		case kAudioFormatiLBC: 					[result appendString:@"iLBC narrow band"];  									break;
		case kAudioFormatDVIIntelIMA: 			[result appendString:@"DVI/Intel IMA ADPCM"];  									break;
		case kAudioFormatMicrosoftGSM: 			[result appendString:@"Microsoft GSM 6.10"];  									break;
		case kAudioFormatAES3: 					[result appendString:@"AES3-2003"];  											break;
		case kAudioFormatEnhancedAC3: 			[result appendString:@"Enhanced AC-3"];  										break;
		case kAudioFormatFLAC: 					[result appendString:@"Free Lossless Audio Codec"];  							break;
		case kAudioFormatOpus: 					[result appendString:@"Opus"];  												break;
		case kAudioFormatAPAC: 					[result appendString:@"Apple Positional Audio Codec"];  						break;

		default:
		{
			unsigned char formatID [5];
			UInt32 formatIDBE = OSSwapHostToBigInt32(asbd->mFormatID);
			memcpy(formatID, &formatIDBE, 4);
			formatID[4] = '\0';

			[result appendFormat:@"'%.4s'", formatID];
			break;
		}
	}

	if(asbd->mFormatFlags != 0)
		[result appendFormat:@" (0x%x), ", asbd->mFormatFlags];
	else
		[result appendString:@", "];

	// PCM
	if(asbd->mFormatID == kAudioFormatLinearPCM) {
		// Bit depth
		UInt32 fractionalBits = (asbd->mFormatFlags & kLinearPCMFormatFlagsSampleFractionMask) >> kLinearPCMFormatFlagsSampleFractionShift;
		if(fractionalBits > 0)
			[result appendFormat:@"%d.%d-bit", asbd->mBitsPerChannel - fractionalBits, fractionalBits];
		else
			[result appendFormat:@"%d-bit", asbd->mBitsPerChannel];

		// Endianness
		bool isInterleaved = !(asbd->mFormatFlags & kAudioFormatFlagIsNonInterleaved);
		UInt32 interleavedChannelCount = (isInterleaved ? asbd->mChannelsPerFrame : 1);
		UInt32 sampleSize = (asbd->mBytesPerFrame > 0 && interleavedChannelCount > 0 ? asbd->mBytesPerFrame / interleavedChannelCount : 0);
		if(sampleSize > 1) {
			if(asbd->mFormatFlags & kLinearPCMFormatFlagIsBigEndian)
				[result appendString:@" big-endian"];
			else
				[result appendString:@" little-endian"];
		}

		// Signedness and integer or floating-point
		bool isInteger = !(asbd->mFormatFlags & kLinearPCMFormatFlagIsFloat);
		if(isInteger) {
			if(asbd->mFormatFlags & kLinearPCMFormatFlagIsSignedInteger)
				[result appendString:@" signed integer"];
			else
				[result appendString:@" unsigned integer"];
		}
		else
			[result appendString:@" float"];

		// Packedness
		if(sampleSize > 0 && ((sampleSize << 3) != asbd->mBitsPerChannel)) {
			if(asbd->mFormatFlags & kLinearPCMFormatFlagIsPacked)
				[result appendFormat:@", packed in %d bytes", sampleSize];
			else
				[result appendFormat:@", unpacked in %d bytes", sampleSize];
		}

		// Alignment
		if((sampleSize > 0 && ((sampleSize << 3) != asbd->mBitsPerChannel)) || ((asbd->mBitsPerChannel & 7) != 0)) {
			if(asbd->mFormatFlags & kLinearPCMFormatFlagIsAlignedHigh)
				[result appendString:@" high-aligned"];
			else
				[result appendString:@" low-aligned"];
		}

		if(!isInterleaved)
			[result appendString:@", deinterleaved"];
	}
	// Lossless
	else if(asbd->mFormatID == kAudioFormatAppleLossless || asbd->mFormatID == kAudioFormatFLAC) {
		UInt32 sourceBitDepth = 0;
		switch(asbd->mFormatFlags) {
			case kAppleLosslessFormatFlag_16BitSourceData:		sourceBitDepth = 16;	break;
			case kAppleLosslessFormatFlag_20BitSourceData:		sourceBitDepth = 20;	break;
			case kAppleLosslessFormatFlag_24BitSourceData:		sourceBitDepth = 24;	break;
			case kAppleLosslessFormatFlag_32BitSourceData:		sourceBitDepth = 32;	break;
		}

		if(sourceBitDepth != 0)
			[result appendFormat:@"from %d-bit source, ", sourceBitDepth];
		else
			[result appendString:@"from UNKNOWN source bit depth, "];

		[result appendFormat:@" %d frames/packet", asbd->mFramesPerPacket];
	}
	// Other
	else
		[result appendFormat:@"%u bits/channel, %u bytes/packet, %u frames/packet, %u bytes/frame", asbd->mBitsPerChannel, asbd->mBytesPerPacket, asbd->mFramesPerPacket, asbd->mBytesPerFrame];

	return result;
}

@end
