// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "Auditor",
    platforms: [
        .macOS(.v12),
    ],
    dependencies: [
        .package(url: "https://github.com/bdrelling/GoatHerb", from: "0.2.1"),
        .package(url: "https://github.com/swift-kipple/Tools", from: "0.3.1"),
    ],
    targets: [
        .testTarget(
            name: "GitHubAuditTests",
            dependencies: [
                .product(name: "GoatHerb", package: "GoatHerb"),
            ]
        ),
    ]
)
