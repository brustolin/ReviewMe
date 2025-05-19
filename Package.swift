// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "ReviewMe",
    platforms: [.iOS(.v14), .tvOS(.v14), .visionOS(.v1)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ReviewMe",
            targets: ["ReviewMe"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ReviewMe"),
        .testTarget(
            name: "ReviewMeTests",
            dependencies: ["ReviewMe"]
        ),
    ]
)
