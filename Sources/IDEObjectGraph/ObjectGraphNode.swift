import SpriteKit

public class ObjectGraphNode: ObjectGraphElement {
  let label: String
  let badge: String?

  var iconNode: SKSpriteNode!
  var labelNode: SKLabelNode!

  var iconHighlightNode: SKShapeNode!
  var labelHighlightNode: SKShapeNode!

  var isHighlighted = false { didSet { updateState() } }
  var isSelected = false { didSet { updateState() } }

  override var layoutSize: CGSize { didSet { updateSize() } }

  public convenience init(imageSystemName: String, backgroundColor: NSColor? = nil, label: String, badge: String? = nil) {
    var image = NSImage(systemSymbolName: imageSystemName, accessibilityDescription: nil)!
      .withSymbolConfiguration(
        NSImage.SymbolConfiguration(pointSize: backgroundColor == nil ? 36 : 30, weight: .regular)
          .applying(NSImage.SymbolConfiguration.init(hierarchicalColor: backgroundColor == nil ? objectColor : .white))
      )!

    if let backgroundColor {
      image = image.withBackgroundColor(backgroundColor)
    }

    self.init(image: image, label: label, badge: badge)
  }

  public init(image: NSImage, label: String, badge: String? = nil) {
    self.label = label
    self.badge = badge
    super.init()

    name = label

    iconNode = SKSpriteNode(texture: SKTexture(image: image))
    addChild(iconNode)

    let iconHighlightSize = 44 + 6 * 2
    let iconHighlightRect = CGRect(
      x: iconHighlightSize / -2,
      y: iconHighlightSize / -2,
      width: iconHighlightSize,
      height: iconHighlightSize
    )

    iconHighlightNode = SKShapeNode(rect: iconHighlightRect, cornerRadius: 5)
    iconHighlightNode.zPosition = -1
    iconHighlightNode.strokeColor = .clear
    iconHighlightNode.isHidden = true
    addChild(iconHighlightNode)
    
    labelNode = SKLabelNode(text: label)
    labelNode.fontName = NSFont.systemFont(ofSize: NSFont.smallSystemFontSize).fontName
    labelNode.fontSize = NSFont.smallSystemFontSize
    //labelNode.truncation
    labelNode.position = CGPoint(x: 0, y: -iconNode.size.height)
    //titleLabel.attributedText
    addChild(labelNode)

    let labelHighlightRect = labelNode.calculateAccumulatedFrame().insetBy(dx: -4, dy: -2.5)
    labelHighlightNode = SKShapeNode(rect: labelHighlightRect, cornerRadius: 5)
    labelHighlightNode.zPosition = -1
    labelHighlightNode.strokeColor = .clear
    labelHighlightNode.isHidden = true
    addChild(labelHighlightNode)

    updateState()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func repositionLabel() {
    labelNode.position = CGPoint(x: 0, y: -iconNode.size.height * labelNode.xScale)
  }

  func updateSize() {
    if layoutSize.height < 70 {
      let action = SKAction.fadeOut(withDuration: ObjectGraphView.defaultAnimationDuration)
      labelNode.run(action)
      labelHighlightNode.run(action)
    } else {
      let action = SKAction.fadeIn(withDuration: ObjectGraphView.defaultAnimationDuration)
      labelNode.run(action)
      labelHighlightNode.run(action)
    }
  }

  override func handleEvent(_ event: NSEvent) {
    let isHoveringIcon = iconNode.contains(event.location(in: self))
    isHighlighted = isHoveringIcon
  }

  func updateState() {
    iconHighlightNode.isHidden = !(isHighlighted || isSelected)
    labelHighlightNode.isHidden = !(isHighlighted || isSelected)
    iconHighlightNode.fillColor = isSelected ? .controlAccentColor.withAlphaComponent(0.2) : .systemGray.withAlphaComponent(0.25)
    labelHighlightNode.fillColor = isSelected ? .controlAccentColor : .systemGray.withAlphaComponent(0.25)
  }
}
