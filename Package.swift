// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "SmileToUnlock",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(name: "SmileToUnlock", targets: ["SmileToUnlock"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "SmileToUnlock", dependencies: [], path: "SmileToUnlock")
    ]
)
