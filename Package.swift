// swift-tools-version: 5.7

import PackageDescription

let composableArchitecture: Target.Dependency = .product(
  name: "ComposableArchitecture",
  package: "swift-composable-architecture"
)
let dependencies: Target.Dependency = .product(
  name: "Dependencies",
  package: "swift-dependencies"
)
let snapshotTesting: Target.Dependency = .product(
  name: "SnapshotTesting",
  package: "swift-snapshot-testing"
)

let package = Package(
  name: "swiftui-classic-games",
  platforms: [
    .iOS(.v16)
  ],
  products: [
    .library(
      name: "AppFeature",
      targets: ["AppFeature"]
    ),
    .library(
      name: "Models",
      targets: ["Models"]
    ),
    .library(
      name: "TicTacToeClient",
      targets: ["TicTacToeClient"]
    ),
    .library(
      name: "TicTacToeFeature",
      targets: ["TicTacToeFeature"]
    ),
    .library(
      name: "TicTacToeRowFeature",
      targets: ["TicTacToeRowFeature"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "0.50.0"),
    .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.11.0"),
    .package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: "0.1.4"),
  ],
  targets: [
    .target(
      name: "AppFeature",
      dependencies: [
        "TicTacToeClient",
        "TicTacToeFeature",
        composableArchitecture
      ]
    ),
    .target(
      name: "Models",
      dependencies: []
    ),
    .target(
      name: "TicTacToeClient",
      dependencies: [
        "Models",
        dependencies
      ]
    ),
    .target(
      name: "TicTacToeFeature",
      dependencies: [
        "Models",
        "TicTacToeClient",
        "TicTacToeRowFeature",
        composableArchitecture,
        dependencies
      ]
    ),
    .target(
      name: "TicTacToeRowFeature",
      dependencies: [
        "Models",
        composableArchitecture
      ]
    ),
    .testTarget(
      name: "AppFeatureTests",
      dependencies: ["AppFeature"]
    ),
    .testTarget(
      name: "TicTacToeFeatureTests",
      dependencies: ["TicTacToeFeature"]
    ),
    .testTarget(
      name: "TicTacToeRowFeatureTests",
      dependencies: ["TicTacToeRowFeature"]
    ),
  ]
)
