import Foundation

let encoder = JSONEncoder()

/*guard let data = try? encoder.encode(board),
      let json = String(data: data, encoding: .utf8) else {
    fatalError("Failed to encode data into json.")
}*/

// Structure definitions
struct PositionCodable: Codable {
    let boxIndex: Int
    let cellIndex: Int
}

struct CellCodable: Codable {
    let position: PositionCodable
    let value: Int?
}

struct BoxCodable: Codable {
    let cells: [CellCodable]

    init(boxIndex: Int, row: Row) {
        var cells = [CellCodable]()
        for cellIndex in 0 ..< 9 {
            cells.append(CellCodable(position: PositionCodable(boxIndex: boxIndex, cellIndex: cellIndex), value: row.getTile(cellIndex: cellIndex).getNumber()))
        }
        self.cells = cells
    }
}

struct BoardCodable: Codable {
    let board: [BoxCodable]
    
    init(board: [[Tile]]) {
        var boxCodable = [BoxCodable]()
        for boxIndex in 0 ..< 9 {
            boxCodable.append(BoxCodable(boxIndex: boxIndex, row: Board.getRows(board: board)[boxIndex]))
        }
        self.board = boxCodable
    }
}
