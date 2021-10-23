
public class Board{

    static var solutionBoard = [[Tile]]() //Creating solution board variable of type 2D Tile array
    var board : [[Tile]] //Creating partial board variable of type 2D Tile array
    var boxes : [Box] //Creating boxes of type Array of Box
    var rows : [Row] //Creating Rows of type Array of Row 
    var columns : [Column] //Creating Columns of type Array of Columns
    
    public init(boardDifficulty: BoardDifficulty){
        Board.solutionBoard = Board.createBoard() // Initializing solution board
        board = Board.partalizeBoard(board: Board.solutionBoard, boardDifficulty: boardDifficulty) //Initializing partial board
        boxes = Board.getBoxes(board: board) //Creating boxes within board
        rows = Board.getRows(board: board) //Creating rows within board 
        columns = Board.getColumns(board: board) //Creating columns within Board
    }

    //Function to get the board difficulty

    public static func getBoardDifficulty(boardDifficulty: String) -> BoardDifficulty? {
        switch (boardDifficulty) {
        case "easy":
            return BoardDifficulty.easy
        case "medium":
            return BoardDifficulty.medium
        case "hard":
            return BoardDifficulty.hard
        case "hell":
            return BoardDifficulty.hell
        default:
            return nil
        }
    }
    
    //Function That Creates a New Line With Randomized Numbers from 1-9. Returns the Line as a Tile for future implementations
    
    private static func createRandomLine() -> [Tile]{        
        var possibleNumbers = [1,2,3,4,5,6,7,8,9] //Array with possible numbers in line
        var randomArrayLine = [Tile]() //Initializing new array that will store randomized tiles

        for _ in (1 ... 9){
            let randomNumber = possibleNumbers.randomElement()! //Randomizes Numbers
            randomArrayLine.append(Tile(num: randomNumber, isMutable: false)) //Adds randomized number to new array

            for x in (0 ..< possibleNumbers.count){
                if(possibleNumbers[x] == randomNumber){
                    possibleNumbers.remove(at: x) //Removes numbers that are already in new array so there are no duplicates in the randomized line
                    break
                }
            }
        }

        return(randomArrayLine)
        
    }

    //Function that Creates a new board of type 2D Array of Tiles with only partial solutions

    private static func partalizeBoard(board: [[Tile]], boardDifficulty: BoardDifficulty) -> [[Tile]]{
        //Switch case to choose how many tiles to remove from each line of the board (As per rules) for each difficulty that the client typed in

        var curBoard = [[Tile]]()
        
        switch (boardDifficulty) {
        case .easy:
            curBoard = removeRandomTilesFromEachLine(board: board, tilesToRemove: 4)//Remove 4 random tiles from each line when easy is chosen
            break
        case .medium:
            curBoard = removeRandomTilesFromEachLine(board: board, tilesToRemove: 5)//Remove 5 random tiles from each line when medium is chosen
            break
        case .hard:
            curBoard = removeRandomTilesFromEachLine(board: board, tilesToRemove: 6)//Remove 6 random tiles from each line when hard is chosen
            break
        case .hell:
            curBoard = removeRandomTilesFromEachLine(board: board, tilesToRemove: 8)//Remove 8 random tiles from each line when hell is chosen
            break
        }

        return curBoard
    }

    //Function to filter board based on Filter parameter

    public static func getFilteredBoard(board: [[Tile]], filter: Filter) -> [[Tile]]{
        switch (filter){
        case .all:
            return board
        case .repeated:
            return checkRepeated(board: board)  //notify whether the entered values are repeated in the same box, row, or column 
        case .incorrect:
            return checkIncorrect(solutionBoard: Board.solutionBoard, partialBoard: board) //notify whether the entered values are incorrect with the solution board 
        }
    }
    private static func compareTileFromBox(boxFirst: Box, boxSecond: Box, cellIndex: Int) -> Bool{
           if let boxFirstValue = boxFirst.getTile(cellIndex: cellIndex).getNumber(),
               let boxSecondValue = boxSecond.getTile(cellIndex: cellIndex).getNumber() {
               return boxFirstValue == boxSecondValue
           }
           return true
    }
    
    private static func checkIncorrect(solutionBoard: [[Tile]], partialBoard: [[Tile]]) -> [[Tile]]{
        let solutionBoxes = getBoxes(board:solutionBoard)
        let partialBoxes = getBoxes(board:partialBoard)
        var incorrectTiles = [[Tile]]()

        for boxIndex in 0..<9{
            incorrectTiles.append(compareBoxes(boxFirst: partialBoxes[boxIndex], boxSecond: solutionBoxes[boxIndex], boxIndex: boxIndex))
        }

        return incorrectTiles
    }

    private static func compareBoxes (boxFirst: Box, boxSecond: Box, boxIndex: Int) -> [Tile] {
        var differentCells = [Tile]()

        for cellIndex in 0..<9 {
            if (!compareTileFromBox(boxFirst: boxFirst, boxSecond: boxSecond, cellIndex: cellIndex)) {
                let value = boxFirst.getTile(cellIndex: cellIndex).getNumber()
                differentCells.append(Tile(num: value, isMutable: true))
            }
        }
        
        return differentCells
    } 

    private static func checkRepeated (board: [[Tile]]) -> [[Tile]] {
        var repeatedBoard = [[Tile]]()
        var repeatedPositions = [PositionCodable]()
        for rowIndex in 0..<getRows(board: board).count {
            let row = getRows(board: board)[rowIndex]
            repeatedPositions += checkRepeatedRow(row: row, rowIndex: rowIndex)
        }

        for columnIndex in 0..<getColumns(board: board).count {
            let column = getColumns(board: board)[columnIndex]
            repeatedPositions += checkRepeatedColumn(column: column, columnIndex: columnIndex)
        }

        for boxIndex in 0..<getBoxes(board: board).count {
            let box = getBoxes(board: board)[boxIndex]
            repeatedPositions += checkRepeatedBox(box: box, boxIndex: boxIndex)
        }

        for x in 0..<9 {
            let positions = repeatedPositions.filter{$0.boxIndex == x}
            let tiles = stripRepeats(positions: positions).map{getTileFromBoard(board: board, position: $0)}

            repeatedBoard.append(tiles)
        }

        return repeatedBoard
    }
    
    private static func getTileFromBoard (board: [[Tile]], position : PositionCodable) -> Tile{
        return getBoxes(board: board)[position.boxIndex].getTile(cellIndex: position.cellIndex)
    } 
    
    private static func stripRepeats (positions : [PositionCodable]) -> [PositionCodable]{
        var cellIndexes = [Int]()
        var newPositions = [PositionCodable]()
        
        for position in positions {
            if (!cellIndexes.contains(position.cellIndex)) {
                cellIndexes.append(position.cellIndex)
                newPositions.append(position)
            }
        }

        return newPositions
    }
    
    private static func checkRepeatedBox (box: Box, boxIndex: Int) -> [PositionCodable] {
        let tiles = box.getTiles()
        var cellIndexesAdded = [Int]()
        var positions = [PositionCodable]()

        for i in 0..<tiles.count - 1 {
            for j in i + 1..<tiles.count{
                if let first = tiles[i].getNumber(),
                   let second = tiles[j].getNumber() {
                    if first == second {
                        if (!cellIndexesAdded.contains(i)) {
                            positions.append(PositionCodable(boxIndex: boxIndex, cellIndex: i))
                            cellIndexesAdded.append(i)
                        }
                        if (!cellIndexesAdded.contains(j)) {
                            positions.append(PositionCodable(boxIndex: boxIndex, cellIndex: j))
                            cellIndexesAdded.append(j)
                        }
                    } 
                }
            }
        }

        return positions
    }
    
    private static func checkRepeatedRow (row: Row, rowIndex: Int) -> [PositionCodable]{
        let tiles = row.getTiles()
        var cellIndexesAdded = [Int]()
        var positions = [PositionCodable]()
        for i in 0..<tiles.count - 1 {
            for j in i + 1..<tiles.count {
                if let first = tiles[i].getNumber(),
                   let second = tiles[j].getNumber() {
                    if first == second {
                        if (!cellIndexesAdded.contains(i)) {
                            let boxIndex = row.getBoxIndex(rowIndex: rowIndex, cellIndex: i)
                            positions.append(PositionCodable(boxIndex: boxIndex, cellIndex: i))
                            cellIndexesAdded.append(i)
                        }
                        if (!cellIndexesAdded.contains(j)) {
                            let boxIndex = row.getBoxIndex(rowIndex: rowIndex, cellIndex: j)
                            positions.append(PositionCodable(boxIndex: boxIndex, cellIndex: j))
                            cellIndexesAdded.append(j)
                        }
                    } 
                }
            }
        }

        return positions
    }

    private static func checkRepeatedColumn (column: Column, columnIndex: Int) -> [PositionCodable]{
        let tiles = column.getTiles()
        var cellIndexesAdded = [Int]()
        var positions = [PositionCodable]()
        
        for i in 0..<tiles.count - 1 {
            for j in i + 1..<tiles.count{
                if let first = tiles[i].getNumber(),
                   let second = tiles[j].getNumber() {
                    if first == second {
                        if (!cellIndexesAdded.contains(i)) {
                            let boxIndex = column.getBoxIndex(columnIndex: columnIndex, cellIndex: i)
                            positions.append(PositionCodable(boxIndex: boxIndex, cellIndex: i))
                            cellIndexesAdded.append(i)
                        }
                        if (!cellIndexesAdded.contains(j)) {
                            let boxIndex = column.getBoxIndex(columnIndex: columnIndex, cellIndex: j)
                            positions.append(PositionCodable(boxIndex: boxIndex, cellIndex: j))
                            cellIndexesAdded.append(j)
                        }
                    } 
                }
            }
        }

        return positions
    }
     

    //Function to get the rows from the board
    
    public static func getRows (board: [[Tile]]) -> [Row] {
        return board.map{ (tiles: [Tile]) -> Row in
            return Row(tiles: tiles)
        }
    }

    //Function to get the columns from the board
    
    private static func getColumns(board: [[Tile]]) -> [Column] {
        var columnTiles: [[Tile]] = [[Tile]](repeating: [Tile](), count: 9)
        
        for i in 0..<board.count {
            for j in 0..<board.count {
                columnTiles[j].append(board[i][j])
            }
        }

        return columnTiles.map{(tiles: [Tile]) -> Column in
            return Column(tiles: tiles)
        }
    }

    //Function to get the boxes from the Board
    
    public static func getBoxes(board: [[Tile]]) -> [Box] {
        var boxes = [Box]()
        for i in 0..<board.count { 
            let xOffset = (i % 3) * 3 
            let yOffset = (i / 3) * 3
            var curTiles = [Tile]()
            for j in 0..<board[i].count {
                let curX = (j % 3) + xOffset
                let curY = (j / 3) + yOffset
                curTiles.append(board[curY][curX])
            }
            boxes.append(Box(tiles: curTiles))

        }

        return boxes
    }
    //Function that removes the numbers from for each line in the board.

    private static func removeRandomTilesFromEachLine(board: [[Tile]], tilesToRemove: Int) -> [[Tile]]{
        var tempBoard = board
        
        for lineNum in 0..<tempBoard.count {
            for curIndex in getRandomIndexes(amount: tilesToRemove) {                
                tempBoard[lineNum][curIndex] = Tile(num: nil, isMutable: true)
            }
        }
        
        return tempBoard
    }

    //Function that randomly chooses which tiles to remove the numbers from in each line.

    private static func getRandomIndexes(amount: Int) -> [Int] {
        var indexes = [Int]()

        for _ in 0..<amount {
            var curNum = Int.random(in: 0...8)
            while indexes.contains(curNum) {
                curNum = Int.random(in: 0...8)
            }
            indexes.append(curNum)
        }
        
        return indexes
    } 
    
    //Function that returns a new array with numbers shifted based on the array inputted as a parameter

    private static func createNewLineByShift(originalArray: [Tile], shift: Int) -> [Tile]{

        var shiftedArray = originalArray //Creats a New array that will shift the numbers

        for x in (0 ..< shift){
            shiftedArray.append(originalArray[x]) //Adds number to array and removes the number from the beginning to create a shift in the values in the array
            shiftedArray.remove(at:0)
        }

        return(shiftedArray)
        
    }

    //Function that prints the arrays to form a completed board
    
    private static func createBoard() -> [[Tile]] {
        var board = [[Tile]]()
        let shifts = [3,3,1,3,3,1,3,3,3]//shift patern to ensure that there are no repeat number in the original board
        var line = createRandomLine()
        
        for i in 0..<shifts.count{
            board.append(line)
            line = createNewLineByShift(originalArray: line, shift: shifts[i])
        }
        
        return board
    }
    
    public func canAlterTile(boxIndex: Int, cellIndex: Int) -> Bool {
        return boxes[boxIndex].getTile(cellIndex: cellIndex).isMutable()
    }

    //Function that returns a board with an altered tile
    
    public func alterBoard(num: Int?, boxIndex: Int, cellIndex: Int) -> Board{
        boxes[boxIndex].setTile(num: num, cellIndex: cellIndex)

        return self
    }
    
    //Function that prints one line of the board as an array
    
    private func getLineString(line: [Tile]) -> String {
        return line.map{$0.getNumberString()}.description
    }

    //Prints all the arrays together so that a board is outputted onto the console
    
    public func getBoardString() -> String {
        var tempString = ""
        for i in 0..<board.count {
            tempString += getLineString(line: board[i]) + "\n"

        }
        return(tempString)
    }
}
