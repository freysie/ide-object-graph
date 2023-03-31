// swift-tools-version: 5.7
import PackageDescription

let package = Package(
  name: "IDEObjectGraph",
  platforms: [
    .macOS(.v12),
  ],
  products: [
    .library(name: "IDEObjectGraph", targets: ["IDEObjectGraph"]),
  ],
  targets: [
    .target(name: "IDEObjectGraph", resources: [.copy("NSObject.png")]),
    .testTarget(name: "IDEObjectGraphTests", dependencies: ["IDEObjectGraph"]),
  ]
)
