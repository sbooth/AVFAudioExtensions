// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "AVFAudioExtensions",
	products: [
		.library(
			name: "AVFAudioExtensions",
			targets: [
				"AVFAudioExtensions",
			]),
	],
	targets: [
		.target(
			name: "AVFAudioExtensions",
			linkerSettings: [
				.linkedFramework("AVFAudio"),
			]),
		.testTarget(
			name: "AVFAudioExtensionsTests",
			dependencies: [
				"AVFAudioExtensions",
			]),
	]
)
