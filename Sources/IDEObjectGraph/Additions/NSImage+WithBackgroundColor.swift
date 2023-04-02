import AppKit

extension CGSize {
  func centered(in rect: CGRect) -> CGRect {
    let centeredPoint = CGPoint(x: rect.minX + (rect.width - width) / 2, y: rect.minY + (rect.height - height) / 2)
    return CGRect(origin: centeredPoint, size: self)
  }
}

extension NSImage {
  func withBackgroundColor(_ color: NSColor, cornerRadius: CGFloat = 5) -> NSImage {
    let bounds = NSRect(origin: .zero, size: NSSize(width: 44, height: 44))
    return NSImage(size: bounds.size, flipped: false) { [self] rect in
      color.setFill()
      NSBezierPath(roundedRect: rect, xRadius: cornerRadius, yRadius: cornerRadius).fill()
      draw(in: size.centered(in: bounds), from: .zero, operation: .sourceOver, fraction: 1)
      return true
    }
  }
}
