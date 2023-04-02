import SpriteKit

class ObjectGraphScene: SKScene, NSGestureRecognizerDelegate {
  override init() {
    super.init(size: CGSize(width: 900, height: 420))
    //super.init(size: .zero)
    backgroundColor = canvasColor
    scaleMode = .resizeFill

    //physicsBody = SKPhysicsBody(edgeLoopFrom: frame.offsetBy(dx: -900, dy: -50))
    //physicsBody?.categoryBitMask = 0b0001

    let cameraNode = SKCameraNode()
    cameraNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
    addChild(cameraNode)
    camera = cameraNode
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
