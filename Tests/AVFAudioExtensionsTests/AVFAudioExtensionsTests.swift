//
// SPDX-FileCopyrightText: 2021 Stephen F. Booth <contact@sbooth.dev>
// SPDX-License-Identifier: MIT
//
// Part of https://github.com/sbooth/AVFAudioExtensions
//

import XCTest
import AVFAudio
@testable import AVFAudioExtensions

final class AVFAudioExtensionsTests: XCTestCase {
	func testChannelLabels() {
		let labels: [AudioChannelLabel] = [kAudioChannelLabel_Left, kAudioChannelLabel_Right]
		labels.withUnsafeBufferPointer {
			let layout = AVAudioChannelLayout(channelLabels: $0.baseAddress!, count: AVAudioChannelCount($0.count))
			XCTAssertNotNil(layout)
			XCTAssert(layout!.channelCount == 2)
		}
	}

	func testChannelLabelString() {
		let layout = AVAudioChannelLayout(channelLabelString: "L R")
		XCTAssertNotNil(layout)
		XCTAssert(layout!.channelCount == 2)
	}

	func testChannelLayoutNames() {
		let layout = AVAudioChannelLayout(layoutTag: kAudioChannelLayoutTag_Stereo)
		XCTAssertNotNil(layout)
		XCTAssertGreaterThan(layout!.layoutName.count, 0)
		XCTAssertGreaterThan(layout!.layoutSimpleName.count, 0)
	}

	func testFormatName() {
		let format = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 2)
		XCTAssertNotNil(format)
		XCTAssertGreaterThan(format!.formatName.count, 0)
	}
}
