
public class Board{

    let solutionBoard : [[Tile]] //Creating solution board variable of type 2D Tile array
    var board : [[Tile]] //Creating partial board variable of type 2D Tile array
    var boxes : [Box]
    var rows : [Row]
    var columns : [Column]
    
    public init(boardDifficulty: String){
        solutionBoard = Board.createBoard() // Initializing solution board
        board = Board.partalizeBoard(board: solutionBoard, boardDifficulty: Board.getBoardDifficulty(boardDifficulty: boardDifficulty)) //Initializing partial board
        boxes = Board.getBoxes(board: board)
        rows = Board.getRows(board: board)
        columns = Board.getColumns(board: board)
    }
// Function that return partial board or error message base on the board difficulty that the client typed in
    public static func getBoardDifficulty(boardDifficulty: String) -> BoardDifficulty {
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
            fatalError("400 Bad Request (difficulty specified doesn't match requirements)")//return error when choosing none of the difficulty above
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

    private static func filterBoard(board: [[Tile]], boardDifficulty: BoardDifficulty, filter: Filter) -> [[Tile]]{
        var currentBoard = board

        switch (filter){
        case .all:
            return board
        case .repeated:
            print("repeated")  //notify wether the entered values are repeating in the same box, row, or column 
        case .incorrect:
            print("incorrect") //notify wether the entered values are incorrect with the solution board 
        }

        return currentBoard
    }
    
    public static func getRows (board: [[Tile]]) -> [Row] {
        return board.map{ (tiles: [Tile]) -> Row in
            return Row(tiles: tiles)
        }
    }
    
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
    
    private static func getBoxes(board: [[Tile]]) -> [Box] {
        var boxes = [Box]()
        for i in 0...8 { 
            let xOffset = (i % 3) * 3  //Creating offset to create the seperate boxes (9 in total) 
            let yOffset = (i / 3) * 3
            var curTiles = [Tile]()
            for j in 0...8 {
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
