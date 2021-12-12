// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GBSwiftAdditions",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "GBSwiftAdditions",
            targets: ["GBSwiftAdditions"]),
        .library(
            name: "GBExtensions",
            targets: ["GBExtensions"]),
        .library(
            name: "GBUIKitAdditions",
            targets: ["GBUIKitAdditions"]),
        .library(
            name: "GBComponents",
            targets: ["GBComponents"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "GBSwiftAdditions",
            dependencies: []),
        .target(
            name: "GBExtensions",
            dependencies: []),
        .target(
            name: "GBUIKitAdditions",
            dependencies: []),
        .target(
            name: "GBComponents",
            dependencies: []),
        .testTarget(
            name: "GBSwiftAdditionsTests",
            dependencies: ["GBSwiftAdditions"]),
        .testTarget(
            name: "GBExtensionsTests",
            dependencies: ["GBExtensions"]),
    ]
)
