// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ZSWTappableLabelSPM",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ZSWTappableLabelSPM",
            targets: ["ZSWTappableLabelSPM"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ZSWTappableLabelSPM",
            dependencies: [
                .target(name: "ZSWTappableLabel"),
                .target(name: "ZSWTaggedString")
            ]),
        .binaryTarget(
            name: "ZSWTappableLabel",
            url: "https://www.dropbox.com/s/hk5bka4dthcpc3y/ZSWTappableLabel.xcframework.zip?dl=1",
            checksum: "f15198fd3cf601840de7097f80fd5abdb03f3df72b470f01fc7ecec1dfc51064"
        ),
        .binaryTarget(
            name: "ZSWTaggedString",
            url: "https://www.dropbox.com/s/q2usk14iexjzg4n/ZSWTaggedString.xcframework.zip?dl=1",
            checksum: "f4c1ffa134ba19dab8c3f6af5a9c0c178d4d9d5952ec5c23cf67efd61044cb40"
        ),
        .testTarget(
            name: "ZSWTappableLabelSPMTests",
            dependencies: ["ZSWTappableLabelSPM"]),
    ]
)
