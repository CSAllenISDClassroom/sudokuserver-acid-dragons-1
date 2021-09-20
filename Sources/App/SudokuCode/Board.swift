public class Board{

    let solutionBoard : [[Tile]] //Creating solution board variable of type 2D Tile array
    var board : [[Tile]] //Creating partial board variable of type 2D Tile array

    public init(boardMode: BoardMode){
        solutionBoard = Board.createBoard() // Initializing solution board
        board = Board.partalizeBoard(board: solutionBoard, boardMode: boardMode) //Initializing partial board
        
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

    private static func partalizeBoard(board: [[Tile]], boardMode: BoardMode) -> [[Tile]]{
        var curBoard = [[Tile]]()

        //Switch case to choose how many tiles to remove from each line of the board (As per rules) for each difficulty
        
        switch (boardMode) {
        case .superEasy:
            curBoard = removeRandomTilesFromEachLine(board: board, tilesToRemove: 3)
            break
        case .easy:
            curBoard = removeRandomTilesFromEachLine(board: board, tilesToRemove: 4)
            break
        case .medium:
            curBoard = removeRandomTilesFromEachLine(board: board, tilesToRemove: 5)
            break
        case .hard:
            curBoard = removeRandomTilesFromEachLine(board: board, tilesToRemove: 6)
            break
        case .superHard:
            curBoard = removeRandomTilesFromEachLine(board: board, tilesToRemove: 7)
            break
        case .impossible:
            curBoard = removeRandomTilesFromEachLine(board: board, tilesToRemove: 8)
            break
        }
        return curBoard

    }

    //Function that removes the numbers from for each line in the board.

    private static func removeRandomTilesFromEachLine(board: [[Tile]], tilesToRemove: Int) -> [[Tile]]{
        var tempBoard = board
        
        for lineNum in 0..<tempBoard.count {
            for curIndex in getRandomIndexes(amount: tilesToRemove) {                
                tempBoard[lineNum][curIndex] = Tile(num: 0, isMutable: true)
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
        let shifts = [3,3,1,3,3,1,3,3,3]
        var line = createRandomLine()
        var lineOffset = 0
        
        for i in 0..<shifts.count{
            board.append(line)
            let shiftedLine = createNewLineByShift(originalArray: line, shift: shifts[i])
            line = getLineWithAssignedPositions(line: shiftedLine, boardOffset: (i / 3) * 3, lineOffset: lineOffset % 9)
            lineOffset += 3
        }
        
        return board
    }

    //Function that gets the lines for board with appropiate indexing
    
    private static func getLineWithAssignedPositions(line: [Tile], boardOffset: Int, lineOffset: Int) -> [Tile] {
        for i in 0 ..< line.count {
            let boxIndex = boardOffset + (i / 3)
            let cellIndex = lineOffset + (i % 3)
            line[i].setPosition(boxIndex: boxIndex, cellIndex: cellIndex)
        }
        
        return line
    }

    //Function that can alter the partial board allowing for numbers to be inserted or removed
    
    public func alterBoard(num: Int?, boxIndex: Int, cellIndex: Int) -> Board{
        for y in 0..<board.count {
            for x in 0..<board.count {
                if (board[y][x].isPosition(boxIndex: boxIndex, cellIndex: cellIndex)) {
                    if let tileNumber = num {
                        board[y][x].setNumber(num: tileNumber)
                    } else {
                        let _ = board[y][x].removeNumber()
                    }
                }
            }
        }

        return self
    }
    
    //Function that removes a tile from the board

    private func removeTileFromLine(line: [Tile], offset: Int) -> [Tile]{
        var curOffset = -1
        return line.map{tile -> Tile in
            curOffset += 1
            if (curOffset == offset) {
                return tile.removeNumber()
            }
            return tile
        }
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

    ///////////////////////////////////////////////////////////////////////////////
    //UNUSED CODE
    //////////////////////////////////////////////////////////////////////
    
    // public func getBoardJSON() -> json {
    //     var tempString = ""
    //     for i in 0..<board.count {
    //         tempString += getLineString(line: board[i])

    //     }
    //     return(json(tempString))
    // }
}
