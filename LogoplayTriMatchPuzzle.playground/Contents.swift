import Cocoa


enum Turn:Int,CaseIterable
{
    case zero = 0
    case onetwenty = 1
    case twoforty = 2

    var description:String { get { return String(self.rawValue) } }
}

enum Color:String
{
    case r,g,b,y,w,bl
    var description:String { get { return self.rawValue } }
}

struct Stone
{
    let nativeColors:[Color]
    var turn:Turn = .zero

    var colorA:Color  { get { return nativeColors[(turn.rawValue + 0 ) % Turn.allCases.count] } }
    var colorB:Color  { get { return nativeColors[(turn.rawValue + 1 ) % Turn.allCases.count] } }
    var colorC:Color  { get { return nativeColors[(turn.rawValue + 2 ) % Turn.allCases.count] } }

    var description:String { get { return ("(\(colorA.description),\(colorB.description),\(colorC.description))" ) } }
}

extension Array where Element == Stone
{
    var description:String { get { return self.map{ $0.description }.joined(separator:",") } }
}
extension Array where Element == Color
{
    var description:String { get { return self.map{ $0.description }.joined(separator:",") } }
}

struct Boardrow
{
    let begin: Color
    let end: Color
    let bottom : [Color]
}

struct Board
{
    var stones:[Stone]
    let rows:[Boardrow] = [     Boardrow(begin: .bl, end: .g, bottom: []),
                                Boardrow(begin: .g, end: .w, bottom: []),
                                Boardrow(begin: .r, end: .g, bottom: []),
                                Boardrow(begin: .b, end: .g, bottom: [.w,.r,.w,.y] ),
                            ]
    var description:String { get { return "board:" + stones.description }  }
    let position2row:[Int:Int] = [  0: 0,

                                    1: 1,
                                    2: 1,
                                    3: 1,

                                    4: 2,
                                    5: 2,
                                    6: 2,
                                    7: 2,
                                    8: 2,

                                    9: 3,
                                    10: 3,
                                    11: 3,
                                    12: 3,
                                    13: 3,
                                    14: 3,
                                    15: 3,
                                    ]

    func checkboard() -> Int
    {
//       print("checkboard:"+self.description)

        ALLSTONES: for (position,stone) in stones.enumerated().reversed()
        {
            let row = rows[ position2row[position]! ]

            switch position
            {
                case 0: if row.begin != stone.colorA || row.end != stone.colorB { return position }

                case 1: if row.begin != stone.colorA { return position }
                case 2: if stones[position-1].colorB != stone.colorB || stones[position-2].colorC != stone.colorC { return position }
                case 3: if stones[position-1].colorA != stone.colorA || row.end != stone.colorB { return position }

                case 4: if row.begin != stone.colorA { return position }
                case 5: if stones[position-1].colorB != stone.colorB || stones[position-4].colorC != stone.colorC { return position }
                case 6: if stones[position-1].colorA != stone.colorA  { return position }
                case 7: if stones[position-1].colorB != stone.colorB || stones[position-4].colorC != stone.colorC { return position }
                case 8: if stones[position-1].colorA != stone.colorA  || row.end != stone.colorB { return position }

                case 9:  if row.begin != stone.colorA                 || row.bottom[0] != stone.colorC          { return position }
                case 10: if stones[position-1].colorB != stone.colorB || stones[position-6].colorC != stone.colorC  { return position }
                case 11: if stones[position-1].colorA != stone.colorA || row.bottom[1] != stone.colorC          { return position }
                case 12: if stones[position-1].colorB != stone.colorB || stones[position-6].colorC != stone.colorC  { return position }
                case 13: if stones[position-1].colorA != stone.colorA || row.bottom[2] != stone.colorC          { return position }
                case 14: if stones[position-1].colorB != stone.colorB || stones[position-6].colorC != stone.colorC  { return position }
                case 15: if stones[position-1].colorA != stone.colorA || row.bottom[3] != stone.colorC || row.end != stone.colorB { return position }

                default:    print("invalid position:\(position)")
                            assert(true)
            }

        }
   //     print("board solved :\(self.description)")
        return -1
    }

}


func testremaining(given:[Stone], remaining originalRemaining:[Stone]) -> Int
{
//    print("testremaining: given:\(stones.description) originalRemaining:\(originalRemaining.description)")

    if originalRemaining.isEmpty
    {
        let board = Board(stones: given)
        return board.checkboard()
    }

    for position in 0..<originalRemaining.count
    {
        var remaining = originalRemaining
        var teststone = remaining.remove(at: position)

        for turn in Turn.allCases
        {
                teststone.turn = turn
            var stones  = given
                stones.append(teststone)

            if -1 == testremaining(given: stones, remaining: [] )
            {
                if remaining.isEmpty
                {
                    print("solved: \( stones.description )")
                }

                testremaining(given: stones, remaining: remaining )
            }
        }
    }
    return 0
}



let testBoard = Board(stones:[ Stone(nativeColors: [.bl,.g,.r]) ])
testBoard.checkboard()

let testBoard2 = Board(stones:[ Stone(nativeColors: [.g,.r,.bl],turn: .onetwenty) ])
testBoard2.checkboard()

let testBoard3 = Board(stones:[ Stone(nativeColors: [.g,.r,.bl],turn: .twoforty) ])
testBoard3.checkboard()

let testBoard4 = Board(stones:[ Stone(nativeColors: [.bl,.g,.r],turn: .zero),

                                Stone(nativeColors: [.g,.bl,.bl],turn: .zero),
                                Stone(nativeColors: [.g,.bl,.r],turn: .zero),
                                Stone(nativeColors: [.g,.w,.y],turn: .zero),

                                 ])
testBoard4.checkboard()


let stones:[Stone] = [
                        Stone(nativeColors: [.w,.b,.bl]),

                        Stone(nativeColors: [.b,.y,.bl]),
                        Stone(nativeColors: [.b,.bl,.w]),
                        Stone(nativeColors: [.r,.g,.y]),

                        Stone(nativeColors: [.r,.w,.y]),
                        Stone(nativeColors: [.y,.g,.b]),
                        Stone(nativeColors: [.g,.y,.w]),
                        Stone(nativeColors: [.bl,.bl,.g]),
                        Stone(nativeColors: [.g,.r,.bl]),

                        Stone(nativeColors: [.w,.w,.b]),
                        Stone(nativeColors: [.y,.g,.bl]),
                        Stone(nativeColors: [.g,.y,.w]),
                        Stone(nativeColors: [.b,.b,.w]),
                        Stone(nativeColors: [.w,.r,.g]),
                        Stone(nativeColors: [.g,.bl,.r]),
                        Stone(nativeColors: [.r,.bl,.g]),
                    ]


testremaining(given:[],remaining:stones)
