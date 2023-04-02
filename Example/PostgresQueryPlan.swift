import AppKit
import IDEObjectGraph

struct PostgresQueryPlan {
  let nodeType: String
  let joinType: String?
  let relationName: String?
  let indexName: String?
  let subplans: [PostgresQueryPlan]

  init(_ array: [[String: [String: Any]]]) {
    self.init(array[0]["Plan"]!)
  }

  init(_ dictionary: [String: Any]) {
    nodeType = dictionary["Node Type"] as! String
    joinType = dictionary["Join Type"] as? String
    relationName = dictionary["Relation Name"] as? String
    indexName = dictionary["Index Name"] as? String
    subplans = (dictionary["Plans"] as? [[String: Any]])?.map { PostgresQueryPlan($0) } ?? []
  }

  var systemSymbolName: String {
    switch nodeType {
    case "Result": return "tablecells.fill"
    case "Aggregate": return "tablecells.fill.badge.ellipsis"
    case "Nested Loop": return "arrow.rectanglepath" //"arrow.triangle.capsulepath"
    case "Hash Join": return "arrowshape.bounce.right.fill"
    case "Seq Scan": return "text.line.first.and.arrowtriangle.forward"
    case "Materialize": return "arrow.up.and.down.and.sparkles"
    case "Sort": return "arrow.up.and.down"
    case "Recursive Union": return "circlebadge.2.fill"
    case "CTE Scan", "WorkTable Scan": return "platter.filled.bottom.and.arrow.down.iphone"
    case "Bitmap Heap Scan": return "tablecells.fill"
    case "Bitmap Index Scan": return "tablecells.fill"
    case "Values Scan": return "circle.hexagongrid.fill"
    case "Index Scan", "Index Only Scan": return "list.bullet.rectangle"
    case "Hash": return "ruler.fill"
    case "WindowAgg": return "window.shade.open" //"window.vertical.closed"
    case "Subquery Scan": return "textformat.subscript"
    case "SetOp": return "gear"
    case "Append": return "text.append"
    case "Function Scan": return "function"
    case "Unique": return "asterisk"
    case "Memoize": return "square.and.arrow.down"
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
    default: return nil
    }
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
}
