# IDE Object Graph

Object graph UI for AppKit.

<img src="/Screenshots/IDEObjectGraph@2x.png?raw=true" width="1012">


## Installation

```swift
.package(url: "https://github.com/freysie/ide-object-graph.git", branch: "main"),
```

```swift
.product(name: "IDEObjectGraph", package: "ide-object-graph"),
```


## Overview

The `ObjectGraphView` lets you visualize a group of objects in a grid. 

Call `setPivotNode(_:)` and implement `incomingReferences(for:)` in your data source to get started.

