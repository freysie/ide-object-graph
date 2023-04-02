// swift-tools-version: 5.7
import PackageDescription

let package = Package(
  name: "ide-object-graph",
  platforms: [
    /// v12 needed for `NSImage.SymbolConfiguration(paletteColors:)` and `NSImage.SymbolConfiguration.applying(_:)`.
    .macOS(.v12),
  ],
  products: [
    .library(name: "IDEObjectGraph", targets: ["IDEObjectGraph"]),
  ],
  targets: [
    .target(name: "IDEObjectGraph"),
  ]
)
