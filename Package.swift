// swift-tools-version: 5.6
//
// SPDX-FileCopyrightText: 2024 Stephen F. Booth <contact@sbooth.dev>
// SPDX-License-Identifier: MIT
//
// Part of https://github.com/sbooth/AVFAudioExtensions
//

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
            cSettings: [
                .headerSearchPath("include/AVFAudioExtensions"),
            ],
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
