// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Auditor",
    platforms: [
        .macOS(.v12),
    ],
    dependencies: [
        .package(url: "https://github.com/bdrelling/GoatHerb", from: "0.3.0"),
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
