// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "calendar-cli",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .executable(name: "calendar-cli", targets: ["calendar-cli"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0")
    ],
    targets: [
        .executableTarget(
            name: "calendar-cli",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ],
            )
    ]
)
