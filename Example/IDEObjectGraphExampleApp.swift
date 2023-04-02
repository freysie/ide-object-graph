import SwiftUI
@testable import IDEObjectGraph

@main
struct IDEObjectGraphExampleApp: App {
  var body: some Scene {
    WindowGroup {
      NSViewControllerPreview { QueryPlanViewController() }
        .navigationTitle("")
    }
  }
}

class QueryPlanViewController: ObjectGraphViewController {
  override func loadView() {
    super.loadView()

    graphView.setPivotNode(exampleQueryPlan.objectGraphNode)
  }

  override func incomingReferences(for node: ObjectGraphNode) -> [ObjectGraphNode] {
    (node.representedObject as? PostgresQueryPlan)?.subplans.map { $0.objectGraphNode } ?? []
  }
}

//let exampleQueryPlan = matchStats
//let exampleQueryPlan = answerDiffs
//let exampleQueryPlan = mandelbrotSet
//let exampleQueryPlan = pieChart
//let exampleQueryPlan = sieveOfEratosthenes
//let exampleQueryPlan = sudokuSolver
let exampleQueryPlan = movingAverage
//let exampleQueryPlan = findUnusedColumns
//let exampleQueryPlan = indexProgress
//let exampleQueryPlan = dependencyReport
//let exampleQueryPlan = vendorWithContacts
//let exampleQueryPlan = salesByStore

let matchStats = PostgresQueryPlan([
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

let answerDiffs = PostgresQueryPlan([
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

let mandelbrotSet = PostgresQueryPlan([
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

let pieChart = PostgresQueryPlan([
  [
    "Plan": [
      "Node Type": "Append",
      "Parallel Aware": false,
      "Async Capable": false,
      "Subplans Removed": 0,
      "Plans": [
        [
          "Node Type": "WindowAgg",
          "Parent Relationship": "InitPlan",
          "Subplan Name": "CTE slices",
          "Parallel Aware": false,
          "Async Capable": false,
          "Plans": [
            [
              "Node Type": "WindowAgg",
              "Parent Relationship": "Outer",
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
            ]
          ]
        ],
        [
          "Node Type": "Subquery Scan",
          "Parent Relationship": "Member",
          "Parallel Aware": false,
          "Async Capable": false,
          "Alias": "*SELECT* 1_1",
          "Plans": [
            [
              "Node Type": "Aggregate",
              "Strategy": "Sorted",
              "Partial Mode": "Simple",
              "Parent Relationship": "Subquery",
              "Parallel Aware": false,
              "Async Capable": false,
              "Group Key": ["((((2.0 * ((generate_series(0, 25)))::numeric) / '25'::numeric) - 1.0))"],
              "Plans": [
                [
                  "Node Type": "Sort",
                  "Parent Relationship": "Outer",
                  "Parallel Aware": false,
                  "Async Capable": false,
                  "Sort Key": ["((((2.0 * ((generate_series(0, 25)))::numeric) / '25'::numeric) - 1.0))", "((((2.0 * ((generate_series(0, 80)))::numeric) / '80'::numeric) - 1.0))"],
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
                          "Node Type": "Result",
                          "Parent Relationship": "Outer",
                          "Parallel Aware": false,
                          "Async Capable": false,
                          "Plans": [
                            [
                              "Node Type": "ProjectSet",
                              "Parent Relationship": "Outer",
                              "Parallel Aware": false,
                              "Async Capable": false,
                              "Plans": [
                                [
                                  "Node Type": "Result",
                                  "Parent Relationship": "Outer",
                                  "Parallel Aware": false,
                                  "Async Capable": false
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
                              "Node Type": "Result",
                              "Parent Relationship": "Outer",
                              "Parallel Aware": false,
                              "Async Capable": false,
                              "Plans": [
                                [
                                  "Node Type": "ProjectSet",
                                  "Parent Relationship": "Outer",
                                  "Parallel Aware": false,
                                  "Async Capable": false,
                                  "Plans": [
                                    [
                                      "Node Type": "Result",
                                      "Parent Relationship": "Outer",
                                      "Parallel Aware": false,
                                      "Async Capable": false
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
                          "Subplan Name": "SubPlan 2",
                          "Parallel Aware": false,
                          "Async Capable": false,
                          "Plans": [
                            [
                              "Node Type": "CTE Scan",
                              "Parent Relationship": "Outer",
                              "Parallel Aware": false,
                              "Async Capable": false,
                              "CTE Name": "slices",
                              "Alias": "slices_1",
                              "Filter": "(radians >= ('3.141592653589793'::double precision + atan2((((((2.0 * ((generate_series(0, 25)))::numeric) / '25'::numeric) - 1.0)))::double precision, ((- ((((2.0 * ((generate_series(0, 80)))::numeric) / '80'::numeric) - 1.0))))::double precision)))"
                            ]
                          ]
                        ]
                      ]
                    ]
                  ]
                ]
              ]
            ]
          ]
        ],
        [
          "Node Type": "CTE Scan",
          "Parent Relationship": "Member",
          "Parallel Aware": false,
          "Async Capable": false,
          "CTE Name": "slices",
          "Alias": "slices"
        ]
      ]
    ]
  ]
])

let sieveOfEratosthenes = PostgresQueryPlan([
  [
    "Plan": [
      "Node Type": "Sort",
      "Parallel Aware": false,
      "Async Capable": false,
      "Sort Key": ["\"*SELECT* 1\".n"],
      "Plans": [
        [
          "Node Type": "Result",
          "Parent Relationship": "InitPlan",
          "Subplan Name": "CTE t0",
          "Parallel Aware": false,
          "Async Capable": false
        ],
        [
          "Node Type": "Recursive Union",
          "Parent Relationship": "InitPlan",
          "Subplan Name": "CTE t1",
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
              "CTE Name": "t1",
              "Alias": "t1_1",
              "Filter": "(n < $2)",
              "Plans": [
                [
                  "Node Type": "CTE Scan",
                  "Parent Relationship": "InitPlan",
                  "Subplan Name": "InitPlan 2 (returns $2)",
                  "Parallel Aware": false,
                  "Async Capable": false,
                  "CTE Name": "t0",
                  "Alias": "t0"
                ]
              ]
            ]
          ]
        ],
        [
          "Node Type": "Recursive Union",
          "Parent Relationship": "InitPlan",
          "Subplan Name": "CTE t2",
          "Parallel Aware": false,
          "Async Capable": false,
          "Plans": [
            [
              "Node Type": "CTE Scan",
              "Parent Relationship": "Outer",
              "Parallel Aware": false,
              "Async Capable": false,
              "CTE Name": "t1",
              "Alias": "t1_2",
              "Filter": "((2 * n) <= $5)",
              "Plans": [
                [
                  "Node Type": "CTE Scan",
                  "Parent Relationship": "InitPlan",
                  "Subplan Name": "InitPlan 4 (returns $5)",
                  "Parallel Aware": false,
                  "Async Capable": false,
                  "CTE Name": "t0",
                  "Alias": "t0_1"
                ]
              ]
            ],
            [
              "Node Type": "Nested Loop",
              "Parent Relationship": "Inner",
              "Parallel Aware": false,
              "Async Capable": false,
              "Join Type": "Inner",
              "Inner Unique": false,
              "Plans": [
                [
                  "Node Type": "CTE Scan",
                  "Parent Relationship": "InitPlan",
                  "Subplan Name": "InitPlan 5 (returns $6)",
                  "Parallel Aware": false,
                  "Async Capable": false,
                  "CTE Name": "t0",
                  "Alias": "t0_2"
                ],
                [
                  "Node Type": "CTE Scan",
                  "Parent Relationship": "Outer",
                  "Parallel Aware": false,
                  "Async Capable": false,
                  "CTE Name": "t1",
                  "Alias": "t1_3"
                ],
                [
                  "Node Type": "Materialize",
                  "Parent Relationship": "Inner",
                  "Parallel Aware": false,
                  "Async Capable": false,
                  "Plans": [
                    [
                      "Node Type": "Aggregate",
                      "Strategy": "Hashed",
                      "Partial Mode": "Simple",
                      "Parent Relationship": "Outer",
                      "Parallel Aware": false,
                      "Async Capable": false,
                      "Group Key": ["t3.k"],
                      "Plans": [
                        [
                          "Node Type": "Subquery Scan",
                          "Parent Relationship": "Outer",
                          "Parallel Aware": false,
                          "Async Capable": false,
                          "Alias": "t3",
                          "Filter": "((t3.k * t3.k) <= $6)",
                          "Plans": [
                            [
                              "Node Type": "WindowAgg",
                              "Parent Relationship": "Subquery",
                              "Parallel Aware": false,
                              "Async Capable": false,
                              "Plans": [
                                [
                                  "Node Type": "WorkTable Scan",
                                  "Parent Relationship": "Outer",
                                  "Parallel Aware": false,
                                  "Async Capable": false,
                                  "CTE Name": "t2",
                                  "Alias": "t2_1"
                                ]
                              ]
                            ]
                          ]
                        ]
                      ]
                    ]
                  ]
                ]
              ]
            ]
          ]
        ],
        [
          "Node Type": "SetOp",
          "Strategy": "Hashed",
          "Parent Relationship": "Outer",
          "Parallel Aware": false,
          "Async Capable": false,
          "Command": "Except",
          "Plans": [
            [
              "Node Type": "Append",
              "Parent Relationship": "Outer",
              "Parallel Aware": false,
              "Async Capable": false,
              "Subplans Removed": 0,
              "Plans": [
                [
                  "Node Type": "Subquery Scan",
                  "Parent Relationship": "Member",
                  "Parallel Aware": false,
                  "Async Capable": false,
                  "Alias": "*SELECT* 1",
                  "Plans": [
                    [
                      "Node Type": "CTE Scan",
                      "Parent Relationship": "Subquery",
                      "Parallel Aware": false,
                      "Async Capable": false,
                      "CTE Name": "t1",
                      "Alias": "t1"
                    ]
                  ]
                ],
                [
                  "Node Type": "Subquery Scan",
                  "Parent Relationship": "Member",
                  "Parallel Aware": false,
                  "Async Capable": false,
                  "Alias": "*SELECT* 2",
                  "Plans": [
                    [
                      "Node Type": "CTE Scan",
                      "Parent Relationship": "Subquery",
                      "Parallel Aware": false,
                      "Async Capable": false,
                      "CTE Name": "t2",
                      "Alias": "t2"
                    ]
                  ]
                ]
              ]
            ]
          ]
        ]
      ]
    ]
  ]
])

let sudokuSolver = PostgresQueryPlan([
  [
    "Plan": [
      "Node Type": "Limit",
      "Parallel Aware": false,
      "Async Capable": false,
      "Plans": [
        [
          "Node Type": "Recursive Union",
          "Parent Relationship": "InitPlan",
          "Subplan Name": "CTE board",
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
              "Node Type": "Nested Loop",
              "Parent Relationship": "Inner",
              "Parallel Aware": false,
              "Async Capable": false,
              "Join Type": "Inner",
              "Inner Unique": false,
              "Join Filter": "((strpos(substr(((OVERLAY(board_1.b PLACING chr((n.n + 98)) FROM strpos((board_1.b)::text, '_'::text) FOR 1))::character(81))::text, (strpos((board_1.b)::text, '_'::text) + 1), (8 - ((strpos((board_1.b)::text, '_'::text) - 1) % 9))), chr((n.n + 98))) = 0) AND (strpos(substr(((OVERLAY(board_1.b PLACING chr((n.n + 98)) FROM strpos((board_1.b)::text, '_'::text) FOR 1))::character(81))::text, (1 + (((strpos((board_1.b)::text, '_'::text) - 1) / 9) * 9)), ((strpos((board_1.b)::text, '_'::text) - 1) % 9)), chr((n.n + 98))) = 0) AND (NOT (SubPlan 1)) AND (NOT (SubPlan 2)))",
              "Plans": [
                [
                  "Node Type": "WorkTable Scan",
                  "Parent Relationship": "Outer",
                  "Parallel Aware": false,
                  "Async Capable": false,
                  "CTE Name": "board",
                  "Alias": "board_1",
                  "Filter": "(strpos((b)::text, '_'::text) > 0)"
                ],
                [
                  "Node Type": "Function Scan",
                  "Parent Relationship": "Inner",
                  "Parallel Aware": false,
                  "Async Capable": false,
                  "Function Name": "generate_series",
                  "Alias": "n"
                ],
                [
                  "Node Type": "Function Scan",
                  "Parent Relationship": "SubPlan",
                  "Subplan Name": "SubPlan 1",
                  "Parallel Aware": false,
                  "Async Capable": false,
                  "Function Name": "generate_series",
                  "Alias": "i",
                  "Filter": "(strpos((board_1.b)::text, '_'::text) <> ((1 + (i * 9)) + ((strpos((board_1.b)::text, '_'::text) - 1) % 9)))"
                ],
                [
                  "Node Type": "Function Scan",
                  "Parent Relationship": "SubPlan",
                  "Subplan Name": "SubPlan 2",
                  "Parallel Aware": false,
                  "Async Capable": false,
                  "Function Name": "generate_series",
                  "Alias": "i_1",
                  "Filter": "(strpos((board_1.b)::text, '_'::text) <> ((((1 + (i % 3)) + ((i / 3) * 9)) + (((strpos((board_1.b)::text, '_'::text) - 1) / 27) * 27)) + ((((strpos((board_1.b)::text, '_'::text) - 1) % 9) / 3) * 3)))"
                ]
              ]
            ]
          ]
        ],
        [
          "Node Type": "Aggregate",
          "Strategy": "Plain",
          "Partial Mode": "Simple",
          "Parent Relationship": "InitPlan",
          "Subplan Name": "InitPlan 6 (returns $10)",
          "Parallel Aware": false,
          "Async Capable": false,
          "Plans": [
            [
              "Node Type": "CTE Scan",
              "Parent Relationship": "Outer",
              "Parallel Aware": false,
              "Async Capable": false,
              "CTE Name": "board",
              "Alias": "board_2"
            ]
          ]
        ],
        [
          "Node Type": "CTE Scan",
          "Parent Relationship": "Outer",
          "Parallel Aware": false,
          "Async Capable": false,
          "CTE Name": "board",
          "Alias": "board",
          "Filter": "(strpos((b)::text, '_'::text) = 0)",
          "Plans": [
            [
              "Node Type": "Aggregate",
              "Strategy": "Plain",
              "Partial Mode": "Simple",
              "Parent Relationship": "SubPlan",
              "Subplan Name": "SubPlan 5",
              "Parallel Aware": false,
              "Async Capable": false,
              "Plans": [
                [
                  "Node Type": "Function Scan",
                  "Parent Relationship": "Outer",
                  "Parallel Aware": false,
                  "Async Capable": false,
                  "Function Name": "generate_series",
                  "Alias": "y"
                ],
                [
                  "Node Type": "Aggregate",
                  "Strategy": "Plain",
                  "Partial Mode": "Simple",
                  "Parent Relationship": "SubPlan",
                  "Subplan Name": "SubPlan 4",
                  "Parallel Aware": false,
                  "Async Capable": false,
                  "Plans": [
                    [
                      "Node Type": "Function Scan",
                      "Parent Relationship": "Outer",
                      "Parallel Aware": false,
                      "Async Capable": false,
                      "Function Name": "generate_series",
                      "Alias": "x"
                    ]
                  ]
                ]
              ]
            ]
          ]
        ]
      ]
    ]
  ]
])

let movingAverage = PostgresQueryPlan([
  [
    "Plan": [
      "Node Type": "Sort",
      "Parallel Aware": false,
      "Async Capable": false,
      "Sort Key": ["data.timeseries", "data.str"],
      "Plans": [
        [
          "Node Type": "Subquery Scan",
          "Parent Relationship": "InitPlan",
          "Subplan Name": "CTE data",
          "Parallel Aware": false,
          "Async Capable": false,
          "Alias": "t",
          "Plans": [
            [
              "Node Type": "ProjectSet",
              "Parent Relationship": "Subquery",
              "Parallel Aware": false,
              "Async Capable": false,
              "Plans": [
                [
                  "Node Type": "Result",
                  "Parent Relationship": "Outer",
                  "Parallel Aware": false,
                  "Async Capable": false
                ]
              ]
            ]
          ]
        ],
        [
          "Node Type": "WindowAgg",
          "Parent Relationship": "Outer",
          "Parallel Aware": false,
          "Async Capable": false,
          "Plans": [
            [
              "Node Type": "Sort",
              "Parent Relationship": "Outer",
              "Parallel Aware": false,
              "Async Capable": false,
              "Sort Key": ["data.str", "data.timeseries"],
              "Plans": [
                [
                  "Node Type": "CTE Scan",
                  "Parent Relationship": "Outer",
                  "Parallel Aware": false,
                  "Async Capable": false,
                  "CTE Name": "data",
                  "Alias": "data"
                ]
              ]
            ]
          ]
        ]
      ]
    ]
  ]
])

let findUnusedColumns = PostgresQueryPlan([
  [
    "Plan": [
      "Node Type": "Sort",
      "Parallel Aware": false,
      "Async Capable": false,
      "Sort Key": ["ns.nspname", "c.relname", "pg_attribute.attname"],
      "Plans": [
        [
          "Node Type": "Nested Loop",
          "Parent Relationship": "Outer",
          "Parallel Aware": false,
          "Async Capable": false,
          "Join Type": "Inner",
          "Inner Unique": true,
          "Plans": [
            [
              "Node Type": "Nested Loop",
              "Parent Relationship": "Outer",
              "Parallel Aware": false,
              "Async Capable": false,
              "Join Type": "Inner",
              "Inner Unique": true,
              "Join Filter": "(c.relnamespace = ns.oid)",
              "Plans": [
                [
                  "Node Type": "Nested Loop",
                  "Parent Relationship": "Outer",
                  "Parallel Aware": false,
                  "Async Capable": false,
                  "Join Type": "Inner",
                  "Inner Unique": true,
                  "Plans": [
                    [
                      "Node Type": "Nested Loop",
                      "Parent Relationship": "Outer",
                      "Parallel Aware": false,
                      "Async Capable": false,
                      "Join Type": "Inner",
                      "Inner Unique": true,
                      "Plans": [
                        [
                          "Node Type": "Seq Scan",
                          "Parent Relationship": "Outer",
                          "Parallel Aware": false,
                          "Async Capable": false,
                          "Relation Name": "pg_statistic",
                          "Alias": "pg_statistic",
                          "Filter": "((stadistinct >= '0'::double precision) AND (stadistinct <= '1'::double precision))"
                        ],
                        [
                          "Node Type": "Index Scan",
                          "Parent Relationship": "Inner",
                          "Parallel Aware": false,
                          "Async Capable": false,
                          "Scan Direction": "Forward",
                          "Index Name": "pg_attribute_relid_attnum_index",
                          "Relation Name": "pg_attribute",
                          "Alias": "pg_attribute",
                          "Index Cond": "((attrelid = pg_statistic.starelid) AND (attnum = pg_statistic.staattnum))",
                          "Filter": "((NOT attisdropped) AND (attstattarget <> 0))"
                        ]
                      ]
                    ],
                    [
                      "Node Type": "Index Scan",
                      "Parent Relationship": "Inner",
                      "Parallel Aware": false,
                      "Async Capable": false,
                      "Scan Direction": "Forward",
                      "Index Name": "pg_class_oid_index",
                      "Relation Name": "pg_class",
                      "Alias": "c",
                      "Index Cond": "(oid = pg_attribute.attrelid)",
                      "Filter": "((reltuples >= '100'::double precision) AND (relkind = 'r'::\"char\"))"
                    ]
                  ]
                ],
                [
                  "Node Type": "Seq Scan",
                  "Parent Relationship": "Inner",
                  "Parallel Aware": false,
                  "Async Capable": false,
                  "Relation Name": "pg_namespace",
                  "Alias": "ns",
                  "Filter": "((nspname !~~ 'pg\\_%'::text) AND (nspname <> 'information_schema'::name))"
                ]
              ]
            ],
            [
              "Node Type": "Index Scan",
              "Parent Relationship": "Inner",
              "Parallel Aware": false,
              "Async Capable": false,
              "Scan Direction": "Forward",
              "Index Name": "pg_type_oid_index",
              "Relation Name": "pg_type",
              "Alias": "t",
              "Index Cond": "(oid = pg_attribute.atttypid)"
            ]
          ]
        ]
      ]
    ]
  ]
])

let indexProgress = PostgresQueryPlan([
  [
    "Plan": [
      "Node Type": "Hash Join",
      "Parallel Aware": false,
      "Async Capable": false,
      "Join Type": "Left",
      "Inner Unique": false,
      "Hash Cond": "(s.pid = s_1.pid)",
      "Plans": [
        [
          "Node Type": "Function Scan",
          "Parent Relationship": "Outer",
          "Parallel Aware": false,
          "Async Capable": false,
          "Function Name": "pg_stat_get_progress_info",
          "Alias": "s"
        ],
        [
          "Node Type": "Hash",
          "Parent Relationship": "Inner",
          "Parallel Aware": false,
          "Async Capable": false,
          "Plans": [
            [
              "Node Type": "Function Scan",
              "Parent Relationship": "Outer",
              "Parallel Aware": false,
              "Async Capable": false,
              "Function Name": "pg_stat_get_activity",
              "Alias": "s_1"
            ]
          ]
        ],
        [
          "Node Type": "Function Scan",
          "Parent Relationship": "SubPlan",
          "Subplan Name": "SubPlan 1",
          "Parallel Aware": false,
          "Async Capable": false,
          "Function Name": "pg_stat_get_activity",
          "Alias": "s_2",
          "Filter": "(pid = s.param6)"
        ]
      ]
    ]
  ]
])

let dependencyReport = PostgresQueryPlan([
  [
    "Plan": [
      "Node Type": "Sort",
      "Parallel Aware": false,
      "Async Capable": false,
      "Sort Key": ["dependency_hierarchy.dependency_chain"],
      "Plans": [
        [
          "Node Type": "Result",
          "Parent Relationship": "InitPlan",
          "Subplan Name": "CTE preference",
          "Parallel Aware": false,
          "Async Capable": false
        ],
        [
          "Node Type": "Aggregate",
          "Strategy": "Sorted",
          "Partial Mode": "Simple",
          "Parent Relationship": "InitPlan",
          "Subplan Name": "CTE dependency_pair",
          "Parallel Aware": false,
          "Async Capable": false,
          "Group Key": ["dep.classid", "dep.objid", "dep.refclassid", "dep.refobjid", "dep.deptype", "rel.object_name", "rel.object_type", "rrel.object_name", "rrel.object_type"],
          "Plans": [
            [
              "Node Type": "Seq Scan",
              "Parent Relationship": "InitPlan",
              "Subplan Name": "CTE relation_object",
              "Parallel Aware": false,
              "Async Capable": false,
              "Relation Name": "pg_class",
              "Alias": "pg_class"
            ],
            [
              "Node Type": "Sort",
              "Parent Relationship": "Outer",
              "Parallel Aware": false,
              "Async Capable": false,
              "Sort Key": ["dep.classid", "dep.objid", "dep.refclassid", "dep.refobjid", "dep.deptype", "rel.object_name", "rel.object_type", "rrel.object_name", "rrel.object_type"],
              "Plans": [
                [
                  "Node Type": "Hash Join",
                  "Parent Relationship": "Outer",
                  "Parallel Aware": false,
                  "Async Capable": false,
                  "Join Type": "Left",
                  "Inner Unique": false,
                  "Hash Cond": "(dep.refobjid = rrel.oid)",
                  "Plans": [
                    [
                      "Node Type": "Hash Join",
                      "Parent Relationship": "Outer",
                      "Parallel Aware": false,
                      "Async Capable": false,
                      "Join Type": "Left",
                      "Inner Unique": false,
                      "Hash Cond": "(dep.objid = rel.oid)",
                      "Plans": [
                        [
                          "Node Type": "Nested Loop",
                          "Parent Relationship": "Outer",
                          "Parallel Aware": false,
                          "Async Capable": false,
                          "Join Type": "Inner",
                          "Inner Unique": false,
                          "Join Filter": "((dep.objid >= (preference.min_oid)::oid) AND ((dep.refobjid >= (preference.min_oid)::oid) OR (dep.refobjid = '2200'::oid)) AND (((dep.classid)::regclass)::text !~ preference.class_exclusion) AND (((dep.refclassid)::regclass)::text !~ preference.class_exclusion) AND (COALESCE(\"substring\"(((dep.objid)::regclass)::text, '^(\\w+)\\.'::text), ''::text) !~ preference.schema_exclusion) AND (COALESCE(\"substring\"(((dep.refobjid)::regclass)::text, '^(\\w+)\\.'::text), ''::text) !~ preference.schema_exclusion))",
                          "Plans": [
                            [
                              "Node Type": "CTE Scan",
                              "Parent Relationship": "Outer",
                              "Parallel Aware": false,
                              "Async Capable": false,
                              "CTE Name": "preference",
                              "Alias": "preference"
                            ],
                            [
                              "Node Type": "Seq Scan",
                              "Parent Relationship": "Inner",
                              "Parallel Aware": false,
                              "Async Capable": false,
                              "Relation Name": "pg_depend",
                              "Alias": "dep",
                              "Filter": "(deptype = ANY ('[n,a]'::\"char\"[]))"
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
                              "Node Type": "CTE Scan",
                              "Parent Relationship": "Outer",
                              "Parallel Aware": false,
                              "Async Capable": false,
                              "CTE Name": "relation_object",
                              "Alias": "rel"
                            ]
                          ]
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
                          "Node Type": "CTE Scan",
                          "Parent Relationship": "Outer",
                          "Parallel Aware": false,
                          "Async Capable": false,
                          "CTE Name": "relation_object",
                          "Alias": "rrel"
                        ]
                      ]
                    ]
                  ]
                ]
              ]
            ],
            [
              "Node Type": "Hash Join",
              "Parent Relationship": "SubPlan",
              "Subplan Name": "SubPlan 3",
              "Parallel Aware": false,
              "Async Capable": false,
              "Join Type": "Inner",
              "Inner Unique": true,
              "Hash Cond": "(r.oid = e.ev_class)",
              "Plans": [
                [
                  "Node Type": "CTE Scan",
                  "Parent Relationship": "Outer",
                  "Parallel Aware": false,
                  "Async Capable": false,
                  "CTE Name": "relation_object",
                  "Alias": "r"
                ],
                [
                  "Node Type": "Hash",
                  "Parent Relationship": "Inner",
                  "Parallel Aware": false,
                  "Async Capable": false,
                  "Plans": [
                    [
                      "Node Type": "Index Scan",
                      "Parent Relationship": "Outer",
                      "Parallel Aware": false,
                      "Async Capable": false,
                      "Scan Direction": "Forward",
                      "Index Name": "pg_rewrite_oid_index",
                      "Relation Name": "pg_rewrite",
                      "Alias": "e",
                      "Index Cond": "(oid = dep.objid)"
                    ]
                  ]
                ]
              ]
            ],
            [
              "Node Type": "Nested Loop",
              "Parent Relationship": "SubPlan",
              "Subplan Name": "SubPlan 4",
              "Parallel Aware": false,
              "Async Capable": false,
              "Join Type": "Inner",
              "Inner Unique": true,
              "Plans": [
                [
                  "Node Type": "Seq Scan",
                  "Parent Relationship": "Outer",
                  "Parallel Aware": false,
                  "Async Capable": false,
                  "Relation Name": "pg_attrdef",
                  "Alias": "d",
                  "Filter": "(oid = dep.objid)"
                ],
                [
                  "Node Type": "Index Scan",
                  "Parent Relationship": "Inner",
                  "Parallel Aware": false,
                  "Async Capable": false,
                  "Scan Direction": "Forward",
                  "Index Name": "pg_attribute_relid_attnum_index",
                  "Relation Name": "pg_attribute",
                  "Alias": "c",
                  "Index Cond": "((attrelid = d.adrelid) AND (attnum = d.adnum))"
                ]
              ]
            ],
            [
              "Node Type": "Seq Scan",
              "Parent Relationship": "SubPlan",
              "Subplan Name": "SubPlan 5",
              "Parallel Aware": false,
              "Async Capable": false,
              "Relation Name": "pg_cast",
              "Alias": "pg_cast",
              "Filter": "(oid = dep.objid)"
            ],
            [
              "Node Type": "Seq Scan",
              "Parent Relationship": "SubPlan",
              "Subplan Name": "SubPlan 6",
              "Parallel Aware": false,
              "Async Capable": false,
              "Relation Name": "pg_constraint",
              "Alias": "pg_constraint",
              "Filter": "(oid = dep.objid)"
            ],
            [
              "Node Type": "Seq Scan",
              "Parent Relationship": "SubPlan",
              "Subplan Name": "SubPlan 7",
              "Parallel Aware": false,
              "Async Capable": false,
              "Relation Name": "pg_extension",
              "Alias": "pg_extension",
              "Filter": "(oid = dep.objid)"
            ],
            [
              "Node Type": "Seq Scan",
              "Parent Relationship": "SubPlan",
              "Subplan Name": "SubPlan 8",
              "Parallel Aware": false,
              "Async Capable": false,
              "Relation Name": "pg_namespace",
              "Alias": "pg_namespace",
              "Filter": "(oid = dep.objid)"
            ],
            [
              "Node Type": "Seq Scan",
              "Parent Relationship": "SubPlan",
              "Subplan Name": "SubPlan 9",
              "Parallel Aware": false,
              "Async Capable": false,
              "Relation Name": "pg_opclass",
              "Alias": "pg_opclass",
              "Filter": "(oid = dep.objid)"
            ],
            [
              "Node Type": "Index Scan",
              "Parent Relationship": "SubPlan",
              "Subplan Name": "SubPlan 10",
              "Parallel Aware": false,
              "Async Capable": false,
              "Scan Direction": "Forward",
              "Index Name": "pg_operator_oid_index",
              "Relation Name": "pg_operator",
              "Alias": "pg_operator",
              "Index Cond": "(oid = dep.objid)"
            ],
            [
              "Node Type": "Seq Scan",
              "Parent Relationship": "SubPlan",
              "Subplan Name": "SubPlan 11",
              "Parallel Aware": false,
              "Async Capable": false,
              "Relation Name": "pg_opfamily",
              "Alias": "pg_opfamily",
              "Filter": "(oid = dep.objid)"
            ],
            [
              "Node Type": "Index Scan",
              "Parent Relationship": "SubPlan",
              "Subplan Name": "SubPlan 12",
              "Parallel Aware": false,
              "Async Capable": false,
              "Scan Direction": "Forward",
              "Index Name": "pg_rewrite_oid_index",
              "Relation Name": "pg_rewrite",
              "Alias": "pg_rewrite",
              "Index Cond": "(oid = dep.objid)"
            ],
            [
              "Node Type": "Seq Scan",
              "Parent Relationship": "SubPlan",
              "Subplan Name": "SubPlan 13",
              "Parallel Aware": false,
              "Async Capable": false,
              "Relation Name": "pg_trigger",
              "Alias": "pg_trigger",
              "Filter": "(oid = dep.objid)"
            ],
            [
              "Node Type": "Seq Scan",
              "Parent Relationship": "SubPlan",
              "Subplan Name": "SubPlan 14",
              "Parallel Aware": false,
              "Async Capable": false,
              "Relation Name": "pg_namespace",
              "Alias": "pg_namespace_1",
              "Filter": "(oid = dep.refobjid)"
            ],
            [
              "Node Type": "Seq Scan",
              "Parent Relationship": "SubPlan",
              "Subplan Name": "SubPlan 15",
              "Parallel Aware": false,
              "Async Capable": false,
              "Relation Name": "pg_opfamily",
              "Alias": "pg_opfamily_1",
              "Filter": "(oid = dep.refobjid)"
            ]
          ]
        ],
        [
          "Node Type": "Recursive Union",
          "Parent Relationship": "InitPlan",
          "Subplan Name": "CTE dependency_hierarchy",
          "Parallel Aware": false,
          "Async Capable": false,
          "Plans": [
            [
              "Node Type": "Unique",
              "Parent Relationship": "Outer",
              "Parallel Aware": false,
              "Async Capable": false,
              "Plans": [
                [
                  "Node Type": "Sort",
                  "Parent Relationship": "Outer",
                  "Parallel Aware": false,
                  "Async Capable": false,
                  "Sort Key": ["root.refobjid", "root.refobj_type", "root.refobj_name COLLATE \"C\"", "(ARRAY[root.refobjid])", "(ARRAY[concat((preference_1.type_ranks ->> root.refobj_type), root.refobj_type, ' ', root.refobj_name)]) COLLATE \"C\""],
                  "Plans": [
                    [
                      "Node Type": "Nested Loop",
                      "Parent Relationship": "Outer",
                      "Parallel Aware": false,
                      "Async Capable": false,
                      "Join Type": "Inner",
                      "Inner Unique": false,
                      "Join Filter": "(root.refobj_name !~ preference_1.schema_exclusion)",
                      "Plans": [
                        [
                          "Node Type": "Hash Join",
                          "Parent Relationship": "Outer",
                          "Parallel Aware": false,
                          "Async Capable": false,
                          "Join Type": "Anti",
                          "Inner Unique": false,
                          "Hash Cond": "(root.refobjid = branch.objid)",
                          "Plans": [
                            [
                              "Node Type": "CTE Scan",
                              "Parent Relationship": "Outer",
                              "Parallel Aware": false,
                              "Async Capable": false,
                              "CTE Name": "dependency_pair",
                              "Alias": "root"
                            ],
                            [
                              "Node Type": "Hash",
                              "Parent Relationship": "Inner",
                              "Parallel Aware": false,
                              "Async Capable": false,
                              "Plans": [
                                [
                                  "Node Type": "CTE Scan",
                                  "Parent Relationship": "Outer",
                                  "Parallel Aware": false,
                                  "Async Capable": false,
                                  "CTE Name": "dependency_pair",
                                  "Alias": "branch"
                                ]
                              ]
                            ]
                          ]
                        ],
                        [
                          "Node Type": "CTE Scan",
                          "Parent Relationship": "Inner",
                          "Parallel Aware": false,
                          "Async Capable": false,
                          "CTE Name": "preference",
                          "Alias": "preference_1"
                        ]
                      ]
                    ]
                  ]
                ]
              ]
            ],
            [
              "Node Type": "Hash Join",
              "Parent Relationship": "Inner",
              "Parallel Aware": false,
              "Async Capable": false,
              "Join Type": "Inner",
              "Inner Unique": false,
              "Hash Cond": "(child.refobjid = parent.objid)",
              "Join Filter": "((child.object_name !~ preference_2.schema_exclusion) AND (child.refobj_name !~ preference_2.schema_exclusion) AND (child.objid <> ALL (parent.dependency_chain)))",
              "Plans": [
                [
                  "Node Type": "CTE Scan",
                  "Parent Relationship": "Outer",
                  "Parallel Aware": false,
                  "Async Capable": false,
                  "CTE Name": "dependency_pair",
                  "Alias": "child"
                ],
                [
                  "Node Type": "Hash",
                  "Parent Relationship": "Inner",
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
                      "Join Filter": "(parent.level < preference_2.max_depth)",
                      "Plans": [
                        [
                          "Node Type": "CTE Scan",
                          "Parent Relationship": "Outer",
                          "Parallel Aware": false,
                          "Async Capable": false,
                          "CTE Name": "preference",
                          "Alias": "preference_2"
                        ],
                        [
                          "Node Type": "WorkTable Scan",
                          "Parent Relationship": "Inner",
                          "Parallel Aware": false,
                          "Async Capable": false,
                          "CTE Name": "dependency_hierarchy",
                          "Alias": "parent"
                        ]
                      ]
                    ]
                  ]
                ]
              ]
            ]
          ]
        ],
        [
          "Node Type": "CTE Scan",
          "Parent Relationship": "Outer",
          "Parallel Aware": false,
          "Async Capable": false,
          "CTE Name": "dependency_hierarchy",
          "Alias": "dependency_hierarchy"
        ]
      ]
    ]
  ]
])

let vendorWithContacts = PostgresQueryPlan([
  [
    "Plan": [
      "Node Type": "Nested Loop",
      "Parallel Aware": false,
      "Async Capable": false,
      "Join Type": "Left",
      "Inner Unique": true,
      "Plans": [
        [
          "Node Type": "Nested Loop",
          "Parent Relationship": "Outer",
          "Parallel Aware": false,
          "Async Capable": false,
          "Join Type": "Inner",
          "Inner Unique": true,
          "Plans": [
            [
              "Node Type": "Nested Loop",
              "Parent Relationship": "Outer",
              "Parallel Aware": false,
              "Async Capable": false,
              "Join Type": "Left",
              "Inner Unique": false,
              "Plans": [
                [
                  "Node Type": "Nested Loop",
                  "Parent Relationship": "Outer",
                  "Parallel Aware": false,
                  "Async Capable": false,
                  "Join Type": "Left",
                  "Inner Unique": false,
                  "Plans": [
                    [
                      "Node Type": "Merge Join",
                      "Parent Relationship": "Outer",
                      "Parallel Aware": false,
                      "Async Capable": false,
                      "Join Type": "Inner",
                      "Inner Unique": false,
                      "Merge Cond": "(p.businessentityid = bec.personid)",
                      "Plans": [
                        [
                          "Node Type": "Index Scan",
                          "Parent Relationship": "Outer",
                          "Parallel Aware": false,
                          "Async Capable": false,
                          "Scan Direction": "Forward",
                          "Index Name": "PK_Person_BusinessEntityID",
                          "Relation Name": "person",
                          "Alias": "p"
                        ],
                        [
                          "Node Type": "Sort",
                          "Parent Relationship": "Inner",
                          "Parallel Aware": false,
                          "Async Capable": false,
                          "Sort Key": ["bec.personid"],
                          "Plans": [
                            [
                              "Node Type": "Hash Join",
                              "Parent Relationship": "Outer",
                              "Parallel Aware": false,
                              "Async Capable": false,
                              "Join Type": "Inner",
                              "Inner Unique": true,
                              "Hash Cond": "(bec.businessentityid = v.businessentityid)",
                              "Plans": [
                                [
                                  "Node Type": "Seq Scan",
                                  "Parent Relationship": "Outer",
                                  "Parallel Aware": false,
                                  "Async Capable": false,
                                  "Relation Name": "businessentitycontact",
                                  "Alias": "bec"
                                ],
                                [
                                  "Node Type": "Hash",
                                  "Parent Relationship": "Inner",
                                  "Parallel Aware": false,
                                  "Async Capable": false,
                                  "Plans": [
                                    [
                                      "Node Type": "Seq Scan",
                                      "Parent Relationship": "Outer",
                                      "Parallel Aware": false,
                                      "Async Capable": false,
                                      "Relation Name": "vendor",
                                      "Alias": "v"
                                    ]
                                  ]
                                ]
                              ]
                            ]
                          ]
                        ]
                      ]
                    ],
                    [
                      "Node Type": "Index Scan",
                      "Parent Relationship": "Inner",
                      "Parallel Aware": false,
                      "Async Capable": false,
                      "Scan Direction": "Forward",
                      "Index Name": "PK_EmailAddress_BusinessEntityID_EmailAddressID",
                      "Relation Name": "emailaddress",
                      "Alias": "ea",
                      "Index Cond": "(businessentityid = p.businessentityid)"
                    ]
                  ]
                ],
                [
                  "Node Type": "Index Only Scan",
                  "Parent Relationship": "Inner",
                  "Parallel Aware": false,
                  "Async Capable": false,
                  "Scan Direction": "Forward",
                  "Index Name": "PK_PersonPhone_BusinessEntityID_PhoneNumber_PhoneNumberTypeID",
                  "Relation Name": "personphone",
                  "Alias": "pp",
                  "Index Cond": "(businessentityid = p.businessentityid)"
                ]
              ]
            ],
            [
              "Node Type": "Memoize",
              "Parent Relationship": "Inner",
              "Parallel Aware": false,
              "Async Capable": false,
              "Cache Key": "bec.contacttypeid",
              "Cache Mode": "logical",
              "Plans": [
                [
                  "Node Type": "Index Scan",
                  "Parent Relationship": "Outer",
                  "Parallel Aware": false,
                  "Async Capable": false,
                  "Scan Direction": "Forward",
                  "Index Name": "PK_ContactType_ContactTypeID",
                  "Relation Name": "contacttype",
                  "Alias": "ct",
                  "Index Cond": "(contacttypeid = bec.contacttypeid)"
                ]
              ]
            ]
          ]
        ],
        [
          "Node Type": "Memoize",
          "Parent Relationship": "Inner",
          "Parallel Aware": false,
          "Async Capable": false,
          "Cache Key": "pp.phonenumbertypeid",
          "Cache Mode": "logical",
          "Plans": [
            [
              "Node Type": "Index Scan",
              "Parent Relationship": "Outer",
              "Parallel Aware": false,
              "Async Capable": false,
              "Scan Direction": "Forward",
              "Index Name": "PK_PhoneNumberType_PhoneNumberTypeID",
              "Relation Name": "phonenumbertype",
              "Alias": "pnt",
              "Index Cond": "(phonenumbertypeid = pp.phonenumbertypeid)"
            ]
          ]
        ]
      ]
    ]
  ]
])

//let salesByStore: [[String: [String: Any]]] = [
//  [
//    "Plan": [
//      "Node Type": "Subquery Scan",
//      "Parallel Aware": false,
//      "Async Capable": false,
//      "Alias": "sales_by_store",
//      "Plans": [
//        [
//          "Node Type": "Aggregate",
//          "Strategy": "Sorted",
//          "Partial Mode": "Simple",
//          "Parent Relationship": "Subquery",
//          "Parallel Aware": false,
//          "Async Capable": false,
//          "Group Key": ["cy.country", "c.city", "s.store_id", "m.first_name", "m.last_name"],
//          "Plans": [
//            [
//              "Node Type": "Sort",
//              "Parent Relationship": "Outer",
//              "Parallel Aware": false,
//              "Async Capable": false,
//              "Sort Key": ["cy.country", "c.city", "s.store_id", "m.first_name", "m.last_name"],
//              "Plans": [
//                [
//                  "Node Type": "Hash Join",
//                  "Parent Relationship": "Outer",
//                  "Parallel Aware": false,
//                  "Async Capable": false,
//                  "Join Type": "Inner",
//                  "Inner Unique": false,
//                  "Hash Cond": "(p.rental_id = r.rental_id)",
//                  "Plans": [
//                    [
//                      "Node Type": "Append",
//                      "Parent Relationship": "Outer",
//                      "Parallel Aware": false,
//                      "Async Capable": false,
//                      "Subplans Removed": 0,
//                      "Plans": [
//                        [
//                          "Node Type": "Seq Scan",
//                          "Parent Relationship": "Member",
//                          "Parallel Aware": false,
//                          "Async Capable": false,
//                          "Relation Name": "payment_p2020_01",
//                          "Alias": "p_1"
//                        ],
//                        [
//                          "Node Type": "Seq Scan",
//                          "Parent Relationship": "Member",
//                          "Parallel Aware": false,
//                          "Async Capable": false,
//                          "Relation Name": "payment_p2020_02",
//                          "Alias": "p_2"
//                        ],
//                        [
//                          "Node Type": "Seq Scan",
//                          "Parent Relationship": "Member",
//                          "Parallel Aware": false,
//                          "Async Capable": false,
//                          "Relation Name": "payment_p2020_03",
//                          "Alias": "p_3"
//                        ],
//                        [
//                          "Node Type": "Seq Scan",
//                          "Parent Relationship": "Member",
//                          "Parallel Aware": false,
//                          "Async Capable": false,
//                          "Relation Name": "payment_p2020_04",
//                          "Alias": "p_4"
//                        ],
//                        [
//                          "Node Type": "Seq Scan",
//                          "Parent Relationship": "Member",
//                          "Parallel Aware": false,
//                          "Async Capable": false,
//                          "Relation Name": "payment_p2020_05",
//                          "Alias": "p_5"
//                        ],
//                        [
//                          "Node Type": "Seq Scan",
//                          "Parent Relationship": "Member",
//                          "Parallel Aware": false,
//                          "Async Capable": false,
//                          "Relation Name": "payment_p2020_06",
//                          "Alias": "p_6"
//                        ]
//                      ]
//                    ],
//                    [
//                      "Node Type": "Hash",
//                      "Parent Relationship": "Inner",
//                      "Parallel Aware": false,
//                      "Async Capable": false,
//                      "Plans": [
//                        [
//                          "Node Type": "Hash Join",
//                          "Parent Relationship": "Outer",
//                          "Parallel Aware": false,
//                          "Async Capable": false,
//                          "Join Type": "Inner",
//                          "Inner Unique": false,
//                          "Hash Cond": "(r.inventory_id = i.inventory_id)",
//                          "Plans": [
//                            [
//                              "Node Type": "Seq Scan",
//                              "Parent Relationship": "Outer",
//                              "Parallel Aware": false,
//                              "Async Capable": false,
//                              "Relation Name": "rental",
//                              "Alias": "r"
//                            ],
//                            [
//                              "Node Type": "Hash",
//                              "Parent Relationship": "Inner",
//                              "Parallel Aware": false,
//                              "Async Capable": false,
//                              "Plans": [
//                                [
//                                  "Node Type": "Hash Join",
//                                  "Parent Relationship": "Outer",
//                                  "Parallel Aware": false,
//                                  "Async Capable": false,
//                                  "Join Type": "Inner",
//                                  "Inner Unique": false,
//                                  "Hash Cond": "(i.store_id = s.store_id)",
//                                  "Plans": [
//                                    [
//                                      "Node Type": "Seq Scan",
//                                      "Parent Relationship": "Outer",
//                                      "Parallel Aware": false,
//                                      "Async Capable": false,
//                                      "Relation Name": "inventory",
//                                      "Alias": "i"
//                                    ],
//                                    [
//                                      "Node Type": "Hash",
//                                      "Parent Relationship": "Inner",
//                                      "Parallel Aware": false,
//                                      "Async Capable": false,
//                                      "Plans": [
//                                        [
//                                          "Node Type": "Hash Join",
//                                          "Parent Relationship": "Outer",
//                                          "Parallel Aware": false,
//                                          "Async Capable": false,
//                                          "Join Type": "Inner",
//                                          "Inner Unique": true,
//                                          "Hash Cond": "(c.country_id = cy.country_id)",
//                                          "Plans": [
//                                            [
//                                              "Node Type": "Hash Join",
//                                              "Parent Relationship": "Outer",
//                                              "Parallel Aware": false,
//                                              "Async Capable": false,
//                                              "Join Type": "Inner",
//                                              "Inner Unique": true,
//                                              "Hash Cond": "(a.city_id = c.city_id)",
//                                              "Plans": [
//                                                [
//                                                  "Node Type": "Hash Join",
//                                                  "Parent Relationship": "Outer",
//                                                  "Parallel Aware": false,
//                                                  "Async Capable": false,
//                                                  "Join Type": "Inner",
//                                                  "Inner Unique": true,
//                                                  "Hash Cond": "(s.address_id = a.address_id)",
//                                                  "Plans": [
//                                                    [
//                                                      "Node Type": "Hash Join",
//                                                      "Parent Relationship": "Outer",
//                                                      "Parallel Aware": false,
//                                                      "Async Capable": false,
//                                                      "Join Type": "Inner",
//                                                      "Inner Unique": true,
//                                                      "Hash Cond": "(s.manager_staff_id = m.staff_id)",
//                                                      "Plans": [
//                                                        [
//                                                          "Node Type": "Seq Scan",
//                                                          "Parent Relationship": "Outer",
//                                                          "Parallel Aware": false,
//                                                          "Async Capable": false,
//                                                          "Relation Name": "store",
//                                                          "Alias": "s"
//                                                        ],
//                                                        [
//                                                          "Node Type": "Hash",
//                                                          "Parent Relationship": "Inner",
//                                                          "Parallel Aware": false,
//                                                          "Async Capable": false,
//                                                          "Plans": [
//                                                            [
//                                                              "Node Type": "Seq Scan",
//                                                              "Parent Relationship": "Outer",
//                                                              "Parallel Aware": false,
//                                                              "Async Capable": false,
//                                                              "Relation Name": "staff",
//                                                              "Alias": "m"
//                                                            ]
//                                                          ]
//                                                        ]
//                                                      ]
//                                                    ],
//                                                    [
//                                                      "Node Type": "Hash",
//                                                      "Parent Relationship": "Inner",
//                                                      "Parallel Aware": false,
//                                                      "Async Capable": false,
//                                                      "Plans": [
//                                                        [
//                                                          "Node Type": "Seq Scan",
//                                                          "Parent Relationship": "Outer",
//                                                          "Parallel Aware": false,
//                                                          "Async Capable": false,
//                                                          "Relation Name": "address",
//                                                          "Alias": "a"
//                                                        ]
//                                                      ]
//                                                    ]
//                                                  ]
//                                                ],
//                                                [
//                                                  "Node Type": "Hash",
//                                                  "Parent Relationship": "Inner",
//                                                  "Parallel Aware": false,
//                                                  "Async Capable": false,
//                                                  "Plans": [
//                                                    [
//                                                      "Node Type": "Seq Scan",
//                                                      "Parent Relationship": "Outer",
//                                                      "Parallel Aware": false,
//                                                      "Async Capable": false,
//                                                      "Relation Name": "city",
//                                                      "Alias": "c"
//                                                    ]
//                                                  ]
//                                                ]
//                                              ]
//                                            ],
//                                            [
//                                              "Node Type": "Hash",
//                                              "Parent Relationship": "Inner",
//                                              "Parallel Aware": false,
//                                              "Async Capable": false,
//                                              "Plans": [
//                                                [
//                                                  "Node Type": "Seq Scan",
//                                                  "Parent Relationship": "Outer",
//                                                  "Parallel Aware": false,
//                                                  "Async Capable": false,
//                                                  "Relation Name": "country",
//                                                  "Alias": "cy"
//                                                ]
//                                              ]
//                                            ]
//                                          ]
//                                        ]
//                                      ]
//                                    ]
//                                  ]
//                                ]
//                              ]
//                            ]
//                          ]
//                        ]
//                      ]
//                    ]
//                  ]
//                ]
//              ]
//            ]
//          ]
//        ]
//      ]
//    ]
//  ]
//]

