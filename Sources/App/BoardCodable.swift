import Foundation

let board = Board()
let encoder = JSONEncoder()

guard let data = try? encoder.encode(board),
      let json = String(data: data, encoding: .utf8) else {
    fatalError("Failed to encode data into json.")
}

// Structure definitions
struct PositionCodable: Codable {
    let boxIndex: Int
    let cellIndex: Int
}

struct CellCodable: Codable {
    let position: Position
    let value: Int?
}

struct BoxCodable: Codable {
    let cells: [CellCodable]

    init(boxIndex: Int) {
        var cells = [CellCodable]()
        for cellIndex in 0 ..< 9 {
            cells.append(CellCodable(position: PositionCodable(boxIndex: boxIndex, cellIndex: cellIndex), value: cellIndex))
        }
        self.cells = cells
    }
}

struct BoardCodable: Codable {
    let board: [BoxCodable]
    
    init() {
        var board = [BoxCodable]()
        for boxIndex in 0 ..< 9 {
            board.append(BoxCodable(boxIndex: boxIndex))
        }
        self.board = board
    }
}
