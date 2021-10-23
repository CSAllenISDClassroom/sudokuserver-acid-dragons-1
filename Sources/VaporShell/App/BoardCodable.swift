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

    init(boxIndex: Int, box: Box, includeNil: Bool) {
        var cells = [CellCodable]()
        for cellIndex in 0 ..< box.getTiles().count {
            if (includeNil) {
                cells.append(CellCodable(position: PositionCodable(boxIndex: boxIndex, cellIndex: cellIndex), value: box.getTile(cellIndex: cellIndex).getNumber()))
            } else {
                if let value = box.getTile(cellIndex: cellIndex).getNumber() {
                    cells.append(CellCodable(position: PositionCodable(boxIndex: boxIndex, cellIndex: cellIndex), value: value))
                }
            }
        }
        self.cells = cells
    }
}

struct BoardCodable: Codable {
    let board: [BoxCodable]
    
    init(board: [[Tile]], includeNil: Bool) {
        var boxCodable = [BoxCodable]()
        for boxIndex in 0 ..< board.count {
            boxCodable.append(BoxCodable(boxIndex: boxIndex, box: Board.getBoxes(board: board)[boxIndex], includeNil: includeNil))
        }
        self.board = boxCodable
    }
}
