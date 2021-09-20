public class Tile {
    
    private var num : Int //Creating a new number variable to represent the number in a tile on the sudoku board
    private var mutable : Bool //Boolean to determine if mutable
    private var boxIndex = 0 //Box index
    private var cellIndex = 0 //Cell Index
    
    public init (num: Int, isMutable: Bool) {
        
        //Initializing the variables

        self.num = num 
        mutable = isMutable
    }

    //Function to get the number of the tile 
    
    public func getNumber () -> Int {
        return num
    }

    //Function to remove the number of the tile
    
    public func removeNumber () -> Tile{
        num = 0
        return self
    }

    //Gives number to tile
    
    public func setNumber (num: Int){
        self.num = num
    }

    //Function that checks if number is mutable on board
    
    public func isMutable () -> Bool {
        return mutable
    }

    //If number on board is 0, it will replace it with a dash to signify an empty slot on the board
    
    public func getNumberString () -> String{
        if (num == 0) {return "-"}
        return String(num)
    }

    //Function that sets the positions of boxIndex and cellIndex
    
    public func setPosition(boxIndex: Int, cellIndex: Int) {
        self.boxIndex = boxIndex
        self.cellIndex = cellIndex
    }
    
    //Returns position as a bool
    
    public func isPosition(boxIndex: Int, cellIndex: Int) -> Bool{
        return self.boxIndex == boxIndex && self.cellIndex == cellIndex
    }
}
