import SpriteKit

var exampleNodes = [
  ObjectGraphNode(systemSymbolName: "cube.transparent.fill", label: "AppDelegate"),

  ObjectGraphNode(systemSymbolName: "pyramid.fill", label: "malloc<65536>", badge: "+848 bytes"),
  ObjectGraphNode(systemSymbolName: "cube.transparent.fill", label: "Application", badge: "_delegate"),

  ObjectGraphNode(systemSymbolName: "cube.transparent.fill", label: "CFXNotificationRegistrar", badge: "+144 bytes"),

  ObjectGraphNode(systemSymbolName: "cube.transparent.fill", label: "CFNotificationCenter", badge: "+16 bytes"),

  ObjectGraphNode(systemSymbolName: "cylinder.fill", backgroundColor: .systemBlue, label: "VM: CoreF…ATA_DIRTY", badge: "__taskCenter"),
  ObjectGraphNode(systemSymbolName: "cube.transparent.fill", label: "NSNotificationCenter", badge: "_impl"),
  ObjectGraphNode(systemSymbolName: "pyramid.fill", label: "malloc<256>"),
  ObjectGraphNode(systemSymbolName: "pyramid.fill", label: "malloc<256>"),
  ObjectGraphNode(systemSymbolName: "pyramid.fill", label: "malloc<256>"),
]

var exampleConnections = [
  0: [1, 2],
  1: [3],
  3: [4],
  //4: [5, 6],
  4: [5, 6, 7],
  //4: [5, 6, 7, 8],
  //4: [5, 6, 7, 8, 9],
]

//ObjectGraphNode(systemSymbolName: "cube.transparent.fill", label: "AppDelegate"),
//let content: (nodes: [ObjectGraphNode], connections: [Int: [Int]]) = {
//  var nodes = [ObjectGraphNode]()
//  var connections = [Int: [Int]]()
//  func collectPlans(_ plan: [String: Any]) {
//    guard let label = plan["Node Type"] as? String else { return }
//    nodes.append(ObjectGraphNode(systemSymbolName: "cube.fill", label: label))
//    guard let subplans = (plan["Plans"] as? [[String: Any]]) else { return }
//    //connections[connections.count] = (connections.count.advanced(by: 1)..<(connections.count.advanced(by: 1)+subplans.count)).map { $0 }
//    subplans.forEach(collectPlans)
//  }
//  collectPlans(exampleExplanation2[0]["Plan"]!)
//
//  print((nodes, connections))
//  return (nodes: nodes, connections: connections)
//}()

struct PostgresQueryPlan {
  let nodeType: String
  let joinType: String?
  let relationName: String?
  let indexName: String?
  private(set) var subplans = [PostgresQueryPlan]()

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
    case "Hash": return "ruler.fill"
    default: return "cube"
    }
  }

  var backgroundColor: NSColor? {
    switch nodeType {
    case "Sort": return .systemBlue
    case "CTE Scan": return .systemOrange
    case "WorkTable Scan": return .systemTeal
    default: return nil
    }
  }
}

extension PostgresQueryPlan {
  var objectGraphNode: ObjectGraphNode {
    let node = ObjectGraphNode(
      systemSymbolName: systemSymbolName,
      backgroundColor: backgroundColor,
      label: indexName ?? relationName ?? nodeType
    )
    node.representedObject = self
    return node
  }
}

let exampleExplanation2 = PostgresQueryPlan([
  [
    "Plan": [
      "Node Type": "Nested Loop",
      "Parallel Aware": false,
      "Async Capable": false,
      "Join Type": "Left",
      "Inner Unique": true,
      "Join Filter": "(a2.question_id = a1.question_id)",
      "Plans": [
        [
          "Node Type": "Hash Join",
          "Parent Relationship": "Outer",
          "Parallel Aware": false,
          "Async Capable": false,
          "Join Type": "Right",
          "Inner Unique": true,
          "Hash Cond": "(q.id = a1.question_id)",
          "Plans": [
            [
              "Node Type": "Seq Scan",
              "Parent Relationship": "Outer",
              "Parallel Aware": false,
              "Async Capable": false,
              "Relation Name": "questions",
              "Alias": "q"
            ],
            [
              "Node Type": "Hash",
              "Parent Relationship": "Inner",
              "Parallel Aware": false,
              "Async Capable": false,
              "Plans": [
                [
                  "Node Type": "Bitmap Heap Scan",
                  "Parent Relationship": "Outer",
                  "Parallel Aware": false,
                  "Async Capable": false,
                  "Relation Name": "answers",
                  "Alias": "a1",
                  "Recheck Cond": "(profile_id = 1)",
                  "Plans": [
                    [
                      "Node Type": "Bitmap Index Scan",
                      "Parent Relationship": "Outer",
                      "Parallel Aware": false,
                      "Async Capable": false,
                      "Index Name": "IDX_f5d7c43148a6a0d2eeef12e605",
                      "Index Cond": "(profile_id = 1)"
                    ]
                  ]
                ]
              ]
            ]
          ]
        ],
        [
          "Node Type": "Materialize",
          "Parent Relationship": "Inner",
          "Parallel Aware": false,
          "Async Capable": false,
          "Plans": [
            [
              "Node Type": "Bitmap Heap Scan",
              "Parent Relationship": "Outer",
              "Parallel Aware": false,
              "Async Capable": false,
              "Relation Name": "answers",
              "Alias": "a2",
              "Recheck Cond": "(profile_id = 2)",
              "Plans": [
                [
                  "Node Type": "Bitmap Index Scan",
                  "Parent Relationship": "Outer",
                  "Parallel Aware": false,
                  "Async Capable": false,
                  "Index Name": "IDX_f5d7c43148a6a0d2eeef12e605",
                  "Index Cond": "(profile_id = 2)"
                ]
              ]
            ]
          ]
        ]
      ]
    ]
  ]
])

let exampleExplanation3 = PostgresQueryPlan([
  [
    "Plan": [
      "Node Type": "Aggregate",
      "Strategy": "Plain",
      "Partial Mode": "Simple",
      "Parallel Aware": false,
      "Async Capable": false,
      "Plans": [
        [
          "Node Type": "Hash Join",
          "Parent Relationship": "Outer",
          "Parallel Aware": false,
          "Async Capable": false,
          "Join Type": "Inner",
          "Inner Unique": true,
          "Hash Cond": "(a1.question_id = a2.question_id)",
          "Plans": [
            [
              "Node Type": "Bitmap Heap Scan",
              "Parent Relationship": "Outer",
              "Parallel Aware": false,
              "Async Capable": false,
              "Relation Name": "answers",
              "Alias": "a1",
              "Recheck Cond": "(profile_id = 1)",
              "Plans": [
                [
                  "Node Type": "Bitmap Index Scan",
                  "Parent Relationship": "Outer",
                  "Parallel Aware": false,
                  "Async Capable": false,
                  "Index Name": "IDX_f5d7c43148a6a0d2eeef12e605",
                  "Index Cond": "(profile_id = 1)"
                ]
              ]
            ],
            [
              "Node Type": "Hash",
              "Parent Relationship": "Inner",
              "Parallel Aware": false,
              "Async Capable": false,
              "Plans": [
                [
                  "Node Type": "Bitmap Heap Scan",
                  "Parent Relationship": "Outer",
                  "Parallel Aware": false,
                  "Async Capable": false,
                  "Relation Name": "answers",
                  "Alias": "a2",
                  "Recheck Cond": "(profile_id = 2)",
                  "Plans": [
                    [
                      "Node Type": "Bitmap Index Scan",
                      "Parent Relationship": "Outer",
                      "Parallel Aware": false,
                      "Async Capable": false,
                      "Index Name": "IDX_f5d7c43148a6a0d2eeef12e605",
                      "Index Cond": "(profile_id = 2)"
                    ]
                  ]
                ]
              ]
            ]
          ]
        ],
        [
          "Node Type": "Aggregate",
          "Strategy": "Plain",
          "Partial Mode": "Simple",
          "Parent Relationship": "SubPlan",
          "Subplan Name": "SubPlan 1",
          "Parallel Aware": false,
          "Async Capable": false,
          "Plans": [
            [
              "Node Type": "Values Scan",
              "Parent Relationship": "Outer",
              "Parallel Aware": false,
              "Async Capable": false,
              "Alias": "*VALUES*"
            ]
          ]
        ],
        [
          "Node Type": "Aggregate",
          "Strategy": "Plain",
          "Partial Mode": "Simple",
          "Parent Relationship": "SubPlan",
          "Subplan Name": "SubPlan 2",
          "Parallel Aware": false,
          "Async Capable": false,
          "Plans": [
            [
              "Node Type": "Values Scan",
              "Parent Relationship": "Outer",
              "Parallel Aware": false,
              "Async Capable": false,
              "Alias": "*VALUES*_1"
            ]
          ]
        ]
      ]
    ]
  ]
])

let exampleExplanation1 = PostgresQueryPlan([
  [
    "Plan": [
      "Node Type": "Aggregate",
      "Strategy": "Sorted",
      "Partial Mode": "Simple",
      "Parallel Aware": false,
      "Async Capable": false,
      "Group Key": ["z.iy"],
      "Plans": [
        [
          "Node Type": "Recursive Union",
          "Parent Relationship": "InitPlan",
          "Subplan Name": "CTE x",
          "Parallel Aware": false,
          "Async Capable": false,
          "Plans": [
            [
              "Node Type": "Result",
              "Parent Relationship": "Outer",
              "Parallel Aware": false,
              "Async Capable": false
            ],
            [
              "Node Type": "WorkTable Scan",
              "Parent Relationship": "Inner",
              "Parallel Aware": false,
              "Async Capable": false,
              "CTE Name": "x",
              "Alias": "x",
              "Filter": "(i < 101)"
            ]
          ]
        ],
        [
          "Node Type": "Recursive Union",
          "Parent Relationship": "InitPlan",
          "Subplan Name": "CTE z",
          "Parallel Aware": false,
          "Async Capable": false,
          "Plans": [
            [
              "Node Type": "Nested Loop",
              "Parent Relationship": "Outer",
              "Parallel Aware": false,
              "Async Capable": false,
              "Join Type": "Inner",
              "Inner Unique": false,
              "Plans": [
                [
                  "Node Type": "CTE Scan",
                  "Parent Relationship": "Outer",
                  "Parallel Aware": false,
                  "Async Capable": false,
                  "CTE Name": "x",
                  "Alias": "x_1"
                ],
                [
                  "Node Type": "CTE Scan",
                  "Parent Relationship": "Inner",
                  "Parallel Aware": false,
                  "Async Capable": false,
                  "CTE Name": "x",
                  "Alias": "x_2"
                ]
              ]
            ],
            [
              "Node Type": "WorkTable Scan",
              "Parent Relationship": "Inner",
              "Parallel Aware": false,
              "Async Capable": false,
              "CTE Name": "z",
              "Alias": "z_1",
              "Filter": "((i < 27) AND (((x * x) + (y * y)) < '16'::double precision))"
            ]
          ]
        ],
        [
          "Node Type": "Sort",
          "Parent Relationship": "Outer",
          "Parallel Aware": false,
          "Async Capable": false,
          "Sort Key": ["z.iy", "z.ix"],
          "Plans": [
            [
              "Node Type": "Aggregate",
              "Strategy": "Hashed",
              "Partial Mode": "Simple",
              "Parent Relationship": "Outer",
              "Parallel Aware": false,
              "Async Capable": false,
              "Group Key": ["z.iy", "z.ix"],
              "Plans": [
                [
                  "Node Type": "CTE Scan",
                  "Parent Relationship": "Outer",
                  "Parallel Aware": false,
                  "Async Capable": false,
                  "CTE Name": "z",
                  "Alias": "z"
                ]
              ]
            ]
          ]
        ]
      ]
    ]
  ]
])

public class ObjectGraphViewController: NSViewController, ObjectGraphViewDataSource {
  var graphView: ObjectGraphView!

  public override func loadView() {
    view = NSView()

    graphView = ObjectGraphView()
    graphView.dataSource = self
    graphView.autoresizingMask = [.width, .height]
    view.addSubview(graphView)

    //graphView.setPivotNode(exampleNodes[0])
    graphView.setPivotNode(exampleExplanation2.objectGraphNode)

    let bar = NSVisualEffectView()
    bar.blendingMode = .withinWindow
    bar.material = .headerView
    bar.translatesAutoresizingMaskIntoConstraints = false
    //bar.isHidden = true
    view.addSubview(bar)

    let zoomOutButton = NSButton(image: Bundle.module.image(forResource: "Zoom Out-Line_Normal")!, target: self, action: #selector(zoomOut))
    let zoomResetButton = NSButton(image: Bundle.module.image(forResource: "Zoom Actual-Line_Normal")!, target: self, action: #selector(zoomReset))
    let zoomInButton = NSButton(image: Bundle.module.image(forResource: "Zoom In-Line_Normal")!, target: self, action: #selector(zoomIn))

    [zoomOutButton, zoomResetButton, zoomInButton].forEach { $0.isBordered = false }

    let stack = NSStackView(views: [zoomOutButton, zoomResetButton, zoomInButton])
    stack.spacing = 0
    view.addSubview(stack)

    NSLayoutConstraint.activate([
      bar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      bar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      bar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      bar.heightAnchor.constraint(equalToConstant: 28),

      zoomOutButton.widthAnchor.constraint(equalToConstant: 27),
      zoomResetButton.widthAnchor.constraint(equalToConstant: 27),
      zoomInButton.widthAnchor.constraint(equalToConstant: 27),

      stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      stack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      stack.heightAnchor.constraint(equalToConstant: 28),
    ])
  }

  public override func viewDidAppear() {
    view.window?.acceptsMouseMovedEvents = true
    //view.window?.initialFirstResponder = graphView
  }

  @objc func zoomOut() {
    //graphView.scene?.camera?.setScale(min((graphView.scene?.camera?.xScale ?? 0) + 0.25, 2))
    graphView.magnify(at: NSPoint(x: view.bounds.midX, y: view.bounds.midY), scale: graphView.scale + 0.25, animated: true)
  }

  @objc func zoomIn() {
    //graphView.scene?.camera?.setScale((graphView.scene?.camera?.xScale ?? 0) - 0.25)
    graphView.magnify(at: NSPoint(x: view.bounds.midX, y: view.bounds.midY), scale: graphView.scale - 0.1, animated: true)
  }

  @objc func zoomReset() {
    graphView.magnify(at: NSPoint(x: view.bounds.midX, y: view.bounds.midY), scale: 1 / 2.5, animated: true)
  }

  public func incomingReferences(for node: ObjectGraphNode) -> [ObjectGraphNode] {
    //guard let identifier = exampleNodes.firstIndex(of: node) else { return [] }
    //guard let connections = exampleConnections[identifier] else { return [] }
    //return connections.map { exampleNodes[$0] }

    (node.representedObject as? PostgresQueryPlan)?.subplans.map { $0.objectGraphNode } ?? []
  }
}

import SwiftUI
struct ObjectGraphViewController_Previews: PreviewProvider {
  static var previews: some View {
    NSViewControllerPreview { ObjectGraphViewController() }
  }
}
