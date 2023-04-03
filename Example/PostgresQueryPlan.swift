import AppKit
import IDEObjectGraph
import Yams

struct PostgresQueryPlan {
  let nodeType: String
  let joinType: String?
  let relationName: String?
  let indexName: String?
  let subplans: [PostgresQueryPlan]
  let info: [Node.Mapping.Element]

  init?(_ node: Node) {
    var node = node
    if let plan = node[0]?["Plan"] { node = plan }
    guard let nodeType = node["Node Type"]?.string else { return nil }
    self.nodeType = nodeType
    joinType = node["Join Type"]?.string
    relationName = node["Relation Name"]?.string
    indexName = node["Index Name"]?.string
    subplans = node["Plans"]?.array().compactMap { PostgresQueryPlan($0) } ?? []
    info = node.mapping!.filter { !["Plans"].contains($0.key) }
  }
}

extension PostgresQueryPlan {
  var objectGraphNode: ObjectGraphNode {
    let node = ObjectGraphNode(
      systemSymbolName: systemSymbolName,
      backgroundColor: backgroundColor,
      //label: indexName ?? relationName ?? nodeType
      label: nodeType
    )
    node.representedObject = self
    return node
  }

  var systemSymbolName: String {
    switch nodeType {
    case "Result":                return "tablecells.fill"
    case "Aggregate":             return "tablecells.fill.badge.ellipsis"
    case "Nested Loop":           return "arrow.rectanglepath" //"arrow.triangle.capsulepath"
    case "Hash Join":             return "arrowshape.bounce.right.fill"
    case "Seq Scan":              return "list.bullet.indent" //"text.line.first.and.arrowtriangle.forward"
    case "Materialize":           return "arrow.up.and.down.and.sparkles"
    case "Sort":                  return "arrow.up.and.down"
    case "Incremetal Sort":       return "arrow.up.and.down"
    case "Recursive Union":       return "circlebadge.2.fill"
    case "CTE Scan":              return "platter.filled.bottom.and.arrow.down.iphone"
    case "WorkTable Scan":        return "platter.filled.bottom.and.arrow.down.iphone"
    case "Bitmap Heap Scan":      return "tablecells.fill"
    case "Bitmap Index Scan":     return "tablecells.fill"
    case "Values Scan":           return "circle.hexagongrid.fill"
    case "Index Scan":            return "list.bullet.rectangle"
    case "Index Only Scan":       return "list.bullet.rectangle"
    case "Hash":                  return "ruler.fill"
    case "WindowAgg":             return "window.shade.open" //"window.vertical.closed"
    case "Subquery Scan":         return "textformat.subscript"
    case "SetOp":                 return "gear"
    case "Append":                return "text.append"
    case "Function Scan":         return "function"
    case "Unique":                return "asterisk"
    case "Memoize":               return "square.and.arrow.down"
    case "Merge Join":            return "arrow.triangle.merge"
    case "Limit":                 return "lessthan"
    case "ProjectSet":            return "videoprojector.fill"
    default: return "cube"
    }
  }

  var backgroundColor: NSColor? {
    switch nodeType {
    case "Sort": return .systemBlue
    case "CTE Scan": return .systemOrange
    case "WorkTable Scan": return .systemTeal
    case "SetOp": return .systemGray
    case "WindowAgg": return .systemPink
    case "Nested Loop": return .systemBlue
    default: return nil
    }
  }
}
