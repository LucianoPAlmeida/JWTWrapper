// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "JWTWrapper",
    products: [
        .library(name: "JWTWrapper", targets: ["JWTWrapper"])
    ],
    targets: [
        .target(
            name: "JWTWrapper",
            path: "JWTWrapper"
        )
    ]
)
