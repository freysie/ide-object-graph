import SpriteKit

let showsDebugElements = false

@objc public protocol ObjectGraphViewDataSource: NSObjectProtocol {
//  -(void)enumerateIncomingReferencesForNode:(unsigned int)arg0 withBlock:(id)arg1 ;
//  -(void)enumerateOutgoingReferencesForNode:(unsigned int)arg0 withBlock:(id)arg1 ;

  @objc optional func incomingReferences(for node: ObjectGraphNode) -> [ObjectGraphNode]

  @objc optional func outgoingReferences(for node: ObjectGraphNode) -> [ObjectGraphNode]
}

public class ObjectGraphView: SKView, NSGestureRecognizerDelegate {
  public static var defaultAnimationDuration: TimeInterval { 0.25 }

  private static let moveAnimationKey = "move"
  private static let scaleAnimationKey = "scale"

  public weak var dataSource: ObjectGraphViewDataSource?

  var elements = [ObjectGraphElement]()
  var nodes = [ObjectGraphNode]()
  var references = [ObjectGraphReference]()
  var debugElements = [ObjectGraphDebugElement]()
  var pivotNodeIdentifier = 0

  var trackedElement: ObjectGraphElement?
  var highlightedElement: ObjectGraphElement?
  var selectedElement: ObjectGraphElement?

  var initialPanPosition = CGPoint.zero
  var initialMagnificationScale = CGFloat.zero

  var layoutManager = ObjectGraphGridLayoutManager()

  var scale = 1.0 // 2.5
  var cellSize = CGSize(width: 75, height: 50)

  public override init(frame frameRect: CGRect) {
    super.init(frame: frameRect)

    wantsLayer = true
    ignoresSiblingOrder = true

    // showsFPS = true
    // showsDrawCount = true
    // showsNodeCount = true
    // showsQuadCount = true

    let pan = NSPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
    pan.delaysPrimaryMouseButtonEvents = false
    addGestureRecognizer(pan)

    let magnification = NSMagnificationGestureRecognizer(target: self, action: #selector(handleMagnificationGesture(_:)))
    addGestureRecognizer(magnification)

    let press = NSPressGestureRecognizer(target: self, action: #selector(handlePressGesture(_:)))
    press.minimumPressDuration = 0
    press.delegate = self
    addGestureRecognizer(press)
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setPivotNode(_ node: ObjectGraphNode) {
    let scene = ObjectGraphScene()

    node.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
    scene.addChild(node)
    nodes.append(node)
    let d = ObjectGraphDebugElement()
    node.addChild(d)
    debugElements.append(d)

    func addNodes(for node: ObjectGraphNode, iteration: Int = 1) {
      guard let dataSource, let references = dataSource.incomingReferences?(for: node) else { return }
      print(references)
      //let yStart = references.count == 1 ? 0.0 : (CGFloat(references.count) * cellSize.height) / (references.count % 2 == 0 ? -4 : -4)
      //let yStart = 0.0
      var yStart = references.count == 1 ? 0.0 : CGFloat(references.count) / -2 * cellSize.height / 2
      if references.count > 1, references.count % 2 != 0 { yStart -= cellSize.height / 4 }
      for (i, referencedNode) in references.reversed().enumerated() {
        referencedNode.position = CGPoint(
          x: node.position.x - cellSize.width,// * CGFloat(iteration),
          y: yStart + node.position.y + cellSize.height * CGFloat(i)
        )
        scene.addChild(referencedNode)
        nodes.append(referencedNode)
        let d = ObjectGraphDebugElement()
        d.gridPosition = CGPoint(x: -CGFloat(iteration), y: CGFloat(i))
        referencedNode.addChild(d)
        debugElements.append(d)

        let reference = ObjectGraphReference()
        reference.position = referencedNode.position
        reference.endGridPosition = CGPoint(x: 0, y: references.count - (1 + i))
        scene.addChild(reference)
        self.references.append(reference)
        
        addNodes(for: referencedNode, iteration: iteration + 1)
      }
    }

    addNodes(for: node)

    //updateScale(2.5)
    updateElementSizes(animated: false)

    presentScene(scene)
  }

  // MARK: - Element Management

  func element(atViewLocation viewLocation: CGPoint) -> ObjectGraphElement? {
    guard let scene else { return nil }
    let location = convert(viewLocation, to: scene)
    return scene.nodes(at: location).compactMap { $0 as? ObjectGraphElement }.first
  }

  func notifyAndTrack(_ element: ObjectGraphElement) {
    guard let currentEvent = NSApp.currentEvent else { return }
    trackedElement?.handleEvent(currentEvent)
    if trackedElement != element {
      trackedElement = element
      element.handleEvent(currentEvent)
    }
  }

  // MARK: - Scaling

  func cellSize(forScale scale: Double) -> CGSize {
    CGSize(width: 75 * scale, height: 50 * scale)
  }

  // func cameraScale(forScale scale: Double) -> Double {
  //   1 / min(scale, 1)
  // }

  func updateScale(_ scale: Double, animated: Bool = false) {
    guard let camera = scene?.camera else { return }

    cellSize = cellSize(forScale: scale)

    if animated {
      camera.removeAction(forKey: Self.scaleAnimationKey)
      let action = SKAction.scale(to: scale, duration: Self.defaultAnimationDuration)
      action.timingMode = .easeInEaseOut
      camera.run(action, withKey: Self.scaleAnimationKey)
    } else {
      camera.setScale(scale)
    }

    self.scale = scale

    updateElementSizes(animated: animated)
  }

  func updateElementSizes(animated: Bool = false) {
    guard pivotNodeIdentifier != -1 else { return }

    // for element in elements {
    //   element.layoutSize = cellSize
    // }

    for node in nodes {
      node.setScale(scale)
      //node.layoutSize = cellSize
      node.layoutSize = CGSize(width: 75.0 / scale, height: 50.0 / scale)
      node.repositionLabel()
    }

    for reference in references {
      reference.setScale(scale)
      //reference.cellSize = 56.0 / scale
      //reference.layoutSize = cellSize
      reference.layoutSize = CGSize(width: 75.0 / scale, height: 50.0 / scale)
      //reference.layoutSize = cellSize
      //node.cellSize = 56.0 / scale
      //node.draw()
      reference.draw()
    }

    for d in debugElements {
      d.isHidden = !showsDebugElements
      d.layoutSize = CGSize(width: 75.0 / scale, height: 50.0 / scale)
    }
  }

  // MARK: - Event Handling

  public override func mouseMoved(with event: NSEvent) {
    if let element = element(atViewLocation: convert(event.locationInWindow, from: nil)) {
      notifyAndTrack(element)
    }
  }

  public override func scrollWheel(with event: NSEvent) {
    guard let camera = scene?.camera else { return }
    camera.position = CGPoint(
      x: camera.position.x + event.scrollingDeltaX * -1,
      y: camera.position.y + event.scrollingDeltaY
    )
  }

  // MARK: - Gesture Handling

  @objc func handlePanGesture(_ sender: NSPanGestureRecognizer) {
    guard let camera = scene?.camera else { return }

    if sender.state == .began {
      initialPanPosition = camera.position
    }

    let translation = sender.translation(in: self)
    let newPosition = CGPoint(
      //x: initialPanPosition.x + translation.x * (-1 / min(1, scale)),
      //y: initialPanPosition.y + translation.y * (-1 / min(1, scale))
      x: initialPanPosition.x + translation.x * -1,
      y: initialPanPosition.y + translation.y * -1
    )
    camera.position = newPosition
  }

  var linearScaleFactor: Double {
    scale < 1 ? log(scale) + 1 : scale
  }

  public func magnify(at point: CGPoint, scale: Double, animated: Bool) {
    //guard let camera = scene?.camera else { return }

//    var scale = scale <= 1 ? exp(scale - 1) : scale
//    scale = max(min(point.x, self.scale), scale)
    //print(scale)


//        let newScale = min(initialMagnificationScale * 1 / abs(sender.magnification + 1), 2)
    //    camera.setScale(scale)

    updateScale(scale, animated: animated)
  }

  @objc func handleMagnificationGesture(_ sender: NSMagnificationGestureRecognizer) {
    guard let camera = scene?.camera else { return }

    if sender.state == .began {
      //initialMagnificationScale = linearScaleFactor
      initialMagnificationScale = camera.xScale
    }

    magnify(at: sender.location(in: self), scale: initialMagnificationScale + sender.magnification, animated: false)
  }

  @objc func handlePressGesture(_ sender: NSPressGestureRecognizer) {
    if let node = selectedElement as? ObjectGraphNode {
      node.isSelected = false
      node.isHighlighted = false
    }

    if let element = element(atViewLocation: sender.location(in: self)) {
      selectedElement = element

      if let node = element as? ObjectGraphNode {
        node.isSelected = true
      }
    } else {
      selectedElement = nil
    }
  }

  public func gestureRecognizer(_: NSGestureRecognizer, shouldRecognizeSimultaneouslyWith _: NSGestureRecognizer) -> Bool {
    true
  }
}
