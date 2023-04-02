import SpriteKit

class ObjectGraphReference: ObjectGraphElement {
  var arrowNode: SKShapeNode!

  var endGridPosition = CGPoint(x: 0, y: 1)

  public override init() {
    super.init()

    zPosition = -1

    arrowNode = SKShapeNode()
    arrowNode.strokeColor = referenceColor
    arrowNode.lineWidth = 1
    arrowNode.lineJoin = .round
    arrowNode.lineCap = .round
    //shapeNode.isAntialiased = false
    //shapeNode.lineJoin = .miter
    //shapeNode.miterLimit = 2
    addChild(arrowNode)

    draw()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func draw() {
    let iconSize = 44.0
    //let cellSize = 56

    //let path = CGPath(ellipseIn: .zero, transform: nil)
    let path = NSBezierPath()
    //path.addArrow(start: CGPoint(x: iconSize / 2 + 8, y: 0), end: CGPoint(x: iconSize / 2 + 8 + gridSize, y: gridSize), pointerLineLength: 8, arrowAngle: CGFloat(Double.pi / 4))
    path.move(to: CGPoint(x: iconSize / 2 + 8, y: 0))
    let arrowStart = CGPoint(x: layoutSize.width / 2 - 2, y: layoutSize.height / 2 * endGridPosition.y)
    if endGridPosition.y != 0 {
      path.line(to: CGPoint(x: layoutSize.width / 2 - 2, y: 0))
      path.line(to: arrowStart)
    }
    path.addArrow(
      start: endGridPosition.y == 0 ? path.currentPoint : arrowStart,
      end: CGPoint(x: iconSize / -2 - 8.5 + layoutSize.width, y: layoutSize.height / 2 * endGridPosition.y),
      pointerLineLength: 8,
      arrowAngle: .pi / 4
    )

    arrowNode.path = path.cgPath
  }
}
