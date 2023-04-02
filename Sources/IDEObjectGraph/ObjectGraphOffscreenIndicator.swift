import SpriteKit

// TODO: finish this:

class ObjectGraphOffscreenIndicator: SKNode {
  var arrowNode: SKSpriteNode!
  var backgroundNode: SKShapeNode!

  public override init() {
    super.init()

    zPosition = 2

    backgroundNode = SKShapeNode(rectOf: CGSize(width: 20, height: 20), cornerRadius: 5)
    backgroundNode.fillColor = .controlAccentColor
    backgroundNode.strokeColor = .clear
    addChild(backgroundNode)

    let image = NSImage(systemSymbolName: "arrow.right", accessibilityDescription: nil)!
      .withSymbolConfiguration(
        NSImage.SymbolConfiguration(pointSize: 12, weight: .medium)
          .applying(NSImage.SymbolConfiguration(paletteColors: [.white]))
      )!

    arrowNode = SKSpriteNode(texture: SKTexture(image: image))
    addChild(arrowNode)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
