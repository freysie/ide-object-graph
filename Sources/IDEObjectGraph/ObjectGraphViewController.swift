import SpriteKit

//var exampleNodes = [
//  ObjectGraphNode(systemSymbolName: "cube.transparent.fill", label: "AppDelegate"),
//
//  ObjectGraphNode(systemSymbolName: "pyramid.fill", label: "malloc<65536>", badge: "+848 bytes"),
//  ObjectGraphNode(systemSymbolName: "cube.transparent.fill", label: "Application", badge: "_delegate"),
//
//  ObjectGraphNode(systemSymbolName: "cube.transparent.fill", label: "CFXNotificationRegistrar", badge: "+144 bytes"),
//
//  ObjectGraphNode(systemSymbolName: "cube.transparent.fill", label: "CFNotificationCenter", badge: "+16 bytes"),
//
//  ObjectGraphNode(systemSymbolName: "cylinder.fill", backgroundColor: .systemBlue, label: "VM: CoreF…ATA_DIRTY", badge: "__taskCenter"),
//  ObjectGraphNode(systemSymbolName: "cube.transparent.fill", label: "NSNotificationCenter", badge: "_impl"),
//  ObjectGraphNode(systemSymbolName: "pyramid.fill", label: "malloc<256>"),
//  ObjectGraphNode(systemSymbolName: "pyramid.fill", label: "malloc<256>"),
//  ObjectGraphNode(systemSymbolName: "pyramid.fill", label: "malloc<256>"),
//]
//
//var exampleConnections = [
//  0: [1, 2],
//  1: [3],
//  3: [4],
//  //4: [5, 6],
//  4: [5, 6, 7],
//  //4: [5, 6, 7, 8],
//  //4: [5, 6, 7, 8, 9],
//]

open class ObjectGraphViewController: NSViewController, ObjectGraphViewDataSource {
  open var graphView: ObjectGraphView!

  open override func loadView() {
    view = NSView()

    graphView = ObjectGraphView()
    graphView.dataSource = self
    graphView.autoresizingMask = [.width, .height]
    view.addSubview(graphView)

    //graphView.setPivotNode(exampleNodes[0])
    //graphView.setPivotNode(exampleQueryPlan.objectGraphNode)

    let bar = NSVisualEffectView()
    bar.blendingMode = .withinWindow
    bar.material = .headerView
    bar.translatesAutoresizingMaskIntoConstraints = false
    //bar.isHidden = true
    view.addSubview(bar)

    let zoomOutButton = NSButton(image: Bundle.module.image(forResource: "zoom.out.raster")!, target: self, action: #selector(zoomOut))
    let zoomResetButton = NSButton(image: Bundle.module.image(forResource: "zoom.actual.raster")!, target: self, action: #selector(zoomReset))
    let zoomInButton = NSButton(image: Bundle.module.image(forResource: "zoom.in.raster")!, target: self, action: #selector(zoomIn))

    [zoomOutButton, zoomResetButton, zoomInButton].forEach { $0.isBordered = false }

    let stack = NSStackView(views: [zoomOutButton, zoomResetButton, zoomInButton])
    stack.spacing = 0
    view.addSubview(stack)

    NSLayoutConstraint.activate([
      bar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      bar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      bar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      bar.heightAnchor.constraint(equalToConstant: 28),

      zoomOutButton.widthAnchor.constraint(equalToConstant: 27),
      zoomResetButton.widthAnchor.constraint(equalToConstant: 27),
      zoomInButton.widthAnchor.constraint(equalToConstant: 27),

      stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      stack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      stack.heightAnchor.constraint(equalToConstant: 28),
    ])
  }

  open override func viewDidAppear() {
    view.window?.acceptsMouseMovedEvents = true
    //view.window?.initialFirstResponder = graphView
  }

  @objc open func zoomOut() {
    //graphView.scene?.camera?.setScale(min((graphView.scene?.camera?.xScale ?? 0) + 0.25, 2))
    graphView.magnify(at: NSPoint(x: view.bounds.midX, y: view.bounds.midY), scale: graphView.scale + 0.25, animated: true)
  }

  @objc open func zoomIn() {
    //graphView.scene?.camera?.setScale((graphView.scene?.camera?.xScale ?? 0) - 0.25)
    graphView.magnify(at: NSPoint(x: view.bounds.midX, y: view.bounds.midY), scale: graphView.scale - 0.25, animated: true)
  }

  @objc open func zoomReset() {
    graphView.magnify(at: NSPoint(x: view.bounds.midX, y: view.bounds.midY), scale: 1 / 2.5, animated: true)
  }

  open func incomingReferences(for node: ObjectGraphNode) -> [ObjectGraphNode] {
    //guard let identifier = exampleNodes.firstIndex(of: node) else { return [] }
    //guard let connections = exampleConnections[identifier] else { return [] }
    //return connections.map { exampleNodes[$0] }

    []
  }
}

import SwiftUI
struct ObjectGraphViewController_Previews: PreviewProvider {
  static var previews: some View {
    NSViewControllerPreview { ObjectGraphViewController() }
  }
}
