// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Rudder-Singular",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .library(
            name: "Rudder-Singular",
            targets: ["Rudder-Singular"]
        )
    ],
    dependencies: [
        .package(name: "Singular", url: "https://github.com/singular-labs/Singular-iOS-SDK", .exact("12.5.0")),
        .package(name: "Rudder", url: "https://github.com/rudderlabs/rudder-sdk-ios", "1.0.0"..<"2.0.0"),
    ],
    targets: [
        .target(
            name: "Rudder-Singular",
            dependencies: [
                .product(name: "Singular", package: "Singular"),
                .product(name: "Rudder", package: "Rudder"),
            ],
            path: "Rudder-Singular",
            sources: ["Classes/"],
            publicHeadersPath: "Classes/",
            cSettings: [
                .headerSearchPath("Classes/")
            ]
        )
    ]
)
