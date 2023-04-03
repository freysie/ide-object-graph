import SwiftUI
@testable import IDEObjectGraph
import Yams

//let exampleQueryPlan = PostgresQueryPlan(named: "Dependency Report")
//let exampleQueryPlan = PostgresQueryPlan(named: "Find Unused Columns")
//let exampleQueryPlan = PostgresQueryPlan(named: "Index Progress")
//let exampleQueryPlan = PostgresQueryPlan(named: "Mandelbrot Set")
//let exampleQueryPlan = PostgresQueryPlan(named: "Match Answer Diff")
let exampleQueryPlan = PostgresQueryPlan(named: "Match Stats")
//let exampleQueryPlan = PostgresQueryPlan(named: "Moving Average")
//let exampleQueryPlan = PostgresQueryPlan(named: "Pie Chart")
//let exampleQueryPlan = PostgresQueryPlan(named: "Sales by Store")
//let exampleQueryPlan = PostgresQueryPlan(named: "Sieve of Eratosthenes")
//let exampleQueryPlan = PostgresQueryPlan(named: "Sudoku Solver")
//let exampleQueryPlan = PostgresQueryPlan(named: "Vendor with Contacts")

@main
struct IDEObjectGraphExampleApp: App {
  var body: some Scene {
    WindowGroup {
      NSViewControllerPreview { QueryPlanViewController() }
        .navigationTitle("")
    }
  }
}

class QueryPlanViewController: ObjectGraphViewController, NSPopoverDelegate {
  var popover: NSPopover?

  override func loadView() {
    super.loadView()

    DispatchQueue.main.async {
      self.graphView.setPivotNode(exampleQueryPlan.objectGraphNode)
    }
  }

  override func incomingReferences(for node: ObjectGraphNode) -> [ObjectGraphNode] {
    (node.representedObject as? PostgresQueryPlan)?.subplans.map { $0.objectGraphNode } ?? []
  }

  func objectGraphView(_ objectGraphView: ObjectGraphView, didClickNode node: ObjectGraphNode) {
    popover?.close()

    guard let plan = node.representedObject as? PostgresQueryPlan else { return }

    let detailsView = QueryPlanDetailsView(
      details: plan.info.map { (key, value) in .init(key: key.string!, value: "\(value.any)") }
    )

    let location = objectGraphView.convert(node.position, from: objectGraphView.scene!)
    let rect = CGRect(x: location.x - 44 / 2, y: location.y - 44 / 2, width: 44, height: 44)

    let popover = NSPopover()
    popover.delegate = self
    popover.behavior = .transient
    //popover.contentSize = NSSize(width: 560, height: 380)
    popover.contentSize = NSSize(width: 450, height: 350)
    popover.contentViewController = NSHostingController(rootView: detailsView)
    popover.show(relativeTo: rect.insetBy(dx: -3, dy: -3), of: view, preferredEdge: .maxY)
    self.popover = popover
  }

  func popoverDidShow(_ notification: Notification) {
    graphView.isPaused = true
  }

  func popoverDidClose(_ notification: Notification) {
    graphView.isPaused = false
  }
}

struct QueryPlanDetailsView: View {
  struct KeyValuePair: Identifiable {
    var id: String { key }
    var key: String
    var value: String
  }

  static let separatedKeys = ["Filter", "Join Filter", "Hash Cond", "Recheck Cond", "Index Cond"]
  
  var details: [KeyValuePair]
  var tableDetails: [KeyValuePair] { details.filter { !Self.separatedKeys.contains($0.key) } }

  var body: some View {
    VStack(alignment: .leading, spacing: 15) {
      Table(tableDetails) {
        TableColumn("Key", value: \.key)
        TableColumn("Value", value: \.value)
      }
      .tableStyle(.bordered(alternatesRowBackgrounds: true))

      if let pair = details.first(where: { Self.separatedKeys.contains($0.key) }) {
        VStack(alignment: .leading, spacing: 5) {
          Text(verbatim: pair.key)
            .font(.system(size: NSFont.smallSystemFontSize, weight: .bold))

          TextEditor(text: .constant(pair.value))
            .monospaced()
            .cornerRadius(3)
            .overlay { RoundedRectangle(cornerRadius: 3).inset(by: 0.5).stroke(.separator) }
            .frame(height: 60)
        }
      }
    }
    .padding(9)
  }
}

extension PostgresQueryPlan {
  init(named name: String) {
    let string = try! String(contentsOf: Bundle.main.url(forResource: "Query Plans/\(name)", withExtension: "json")!)
    self.init(try! Yams.compose(yaml: string)!)!
  }
}
