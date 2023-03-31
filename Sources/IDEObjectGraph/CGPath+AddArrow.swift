import AppKit

extension NSBezierPath {
  func addArrow(start: CGPoint, end: CGPoint, pointerLineLength: CGFloat, arrowAngle: CGFloat) {
    move(to: start)
    // line(to: CGPoint(x: end.x / 2, y: start.y))
    // line(to: CGPoint(x: end.x / 2, y: end.y))
    line(to: end)

    let startEndAngle = atan((end.y - start.y) / (end.x - start.x)) + ((end.x - start.x) < 0 ? CGFloat(Double.pi) : 0)
    let arrowLine1 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle + arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle + arrowAngle))
    let arrowLine2 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle - arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle - arrowAngle))

    line(to: arrowLine1)
    move(to: end)
    line(to: arrowLine2)
  }
}

extension NSBezierPath {
  var cgPath: CGPath {
    let path = CGMutablePath()
    var points = [CGPoint](repeating: .zero, count: 3)
    for i in 0..<elementCount {
      let type = element(at: i, associatedPoints: &points)

      switch type {
      case .moveTo: path.move(to: points[0])
      case .lineTo: path.addLine(to: points[0])
      case .curveTo: path.addCurve(to: points[2], control1: points[0], control2: points[1])
      case .closePath: path.closeSubpath()
      @unknown default: break
      }
    }
    return path
  }
}
