import SpriteKit

public class ObjectGraphElement: SKNode {
  var layoutSize = CGSize(width: 75 * 2.5, height: 50 * 2.5)
  var gridPosition = CGPoint.zero

  func handleEvent(_ event: NSEvent) {}
}

public class ObjectGraphDebugElement: ObjectGraphElement {
  var strokeNode: SKShapeNode!
  var labelNode: SKLabelNode!

  override var gridPosition: CGPoint { didSet { update() } }
  override var layoutSize: CGSize { didSet { update() } }

  public override init() {
    super.init()

    zPosition = -2

    strokeNode = SKShapeNode(rectOf: layoutSize)
    strokeNode.lineWidth = 1
    strokeNode.strokeColor = .systemGray.withAlphaComponent(0.5)
    addChild(strokeNode)

    let font = NSFont.systemFont(ofSize: NSFont.smallSystemFontSize)
    labelNode = SKLabelNode(fontNamed: font.fontName)
    labelNode.fontSize = NSFont.smallSystemFontSize
    labelNode.fontColor = .systemGray
    labelNode.horizontalAlignmentMode = .left
    labelNode.text = "(0, 0)"
    addChild(labelNode)

    update()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func update() {
    strokeNode.path = SKShapeNode(rectOf: layoutSize).path
    labelNode.position = CGPoint(x: layoutSize.width / -2, y: layoutSize.height / -2)
    labelNode.text = "(\(Int(gridPosition.x)), \(Int(gridPosition.y)))"
  }
}
