import Foundation

let encoder = JSONEncoder()

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
    
    init(board: [[Tile]], includeNil: Bool, shouldConvertToBoxes : Bool = true) {
        var boxCodable = [BoxCodable]()
        for boxIndex in 0 ..< board.count {
            let box = shouldConvertToBoxes ? Board.getBoxes(board: board)[boxIndex] : Box(tiles: board[boxIndex])
            boxCodable.append(BoxCodable(boxIndex: boxIndex, box: box, includeNil: includeNil))
        }
        self.board = boxCodable
    }
}
