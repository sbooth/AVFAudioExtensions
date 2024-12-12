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
		XCTAssertNotNil(layout!.layoutName)
		XCTAssertNotNil(layout!.layoutSimpleName)
	}
}
