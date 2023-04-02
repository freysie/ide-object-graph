import SwiftUI
@testable import IDEObjectGraph

@main
struct IDEObjectGraphExampleApp: App {
  var body: some Scene {
    WindowGroup {
      NSViewControllerPreview { ObjectGraphViewController() }
        .navigationTitle("")
    }
  }
}

//var exampleNodes = [
//  ObjectGraphNode(image: Image(systemName: "cube.fill"), label: "NSNotificationCenter", badge: "_impl"),
//  //ObjectGraphNode(image: Image(systemName: "cube.fill"), label: "CFNotificationCenter", badge: "+16 bytes"),
//]

// payment
// payment_p2007_02
// payment_p2007_03
// --
// append
// --
// customer_pkey
// sort
// --
// merge left join

let exampleExplanation2 = [
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
]

let exampleExplanation = [
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
]
