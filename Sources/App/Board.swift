public class Board{


    //////////////////////////////////////////////////////////////////////
    //TILE IS USED FOR FUTURE IMPLEMENTATIONS
    //ARRAY CONSISTS OF TILES UNLESS OTHERWISE SPECIFIED
    //TILES WILL BE USED TO CHECK EACH INDIVUAL TILE AGAINST USER INPUT
    //////////////////////////////////////////////////////////////////////

    //UNUSED CODE///////////
    //
    //let board : [[Tile]]!
    //
    ///////////////////////

    public init(){

        //UNUSED CODE/////////////
        //
        // board = createBoard()
        //
        ////////////////////////
    }

    //Function That Creates a New Line With Randomized Numbers from 1-9. Returns the Line as a Tile for future implementations
    
    private func createRandomLine() -> [Tile]{
        
        var possibleNumbers = [1,2,3,4,5,6,7,8,9] //Array with possible numbers in line
        var randomArrayLine = [Tile]() //Initializing new array that will store randomized tiles

        for _ in (1 ... 9){

            let randomNumber = possibleNumbers.randomElement()! //Randomizes Numbers
            randomArrayLine.append(Tile(num: randomNumber)) //Adds randomized number to new array

            for x in (0 ..< possibleNumbers.count){

                if(possibleNumbers[x] == randomNumber){

                    possibleNumbers.remove(at: x) //Removes numbers that are already in new array so there are no duplicates in the randomized line
                    break

                }
            }
        }

        return(randomArrayLine)
        
    }

    //Function that returns a new array with numbers shifted based on the array inputted as a parameter

    private func createNewLineByShift(originalArray: [Tile], shift: Int) -> [Tile]{

        var shiftedArray = originalArray //Creats a New array that will shift the numbers

        for x in (0 ..< shift){
            
            shiftedArray.append(originalArray[x]) //Adds number to array and removes the number from the beginning to create a shift in the values in the array
            shiftedArray.remove(at:0)
        }

        return(shiftedArray)
        
    }

    //Function that prints the arrays to form a completed board

    public func createBoard() -> [[Tile]] {
        
        var board = [[Tile]]()
        let shifts = [3,3,1,3,3,1,3,3]
        var line = createRandomLine()

        for i in 0..<shifts.count{
            
            board.append(line)
            line = createNewLineByShift(originalArray: line, shift: shifts[i])
        }

        return board;
    }

    //Function that prints one line of the board as an array
    
    private func printLine(line: [Tile]) {
        
        print(line.map{$0.getNumber()})
    }

    //Prints all the arrays together so that a board is outputted onto the console
    
    public func printBoard(board: [[Tile]]) {
        
        for i in 0..<board.count {
            
            printLine(line: board[i])
        }
    }
}
