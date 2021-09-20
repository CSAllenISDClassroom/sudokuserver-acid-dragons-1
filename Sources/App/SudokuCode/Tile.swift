public class Tile {
    
    private var num : Int //Creating a new number variable to represent the number in a tile on the sudoku board
    private var mutable : Bool
    private var boxIndex = 0
    private var cellIndex = 0
    
    public init (num: Int, isMutable: Bool) {
        self.num = num //Initializing the variables
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

    public func setNumber (num: Int){
        self.num = num
    }

    public func isMutable () -> Bool {
        return mutable
    }
    
    public func getNumberString () -> String{
        if (num == 0) {return "-"}
        return String(num)
    }

    public func setPosition(boxIndex: Int, cellIndex: Int) {
        self.boxIndex = boxIndex
        self.cellIndex = cellIndex
    }

    public func isPosition(boxIndex: Int, cellIndex: Int) -> Bool{
        return self.boxIndex == boxIndex && self.cellIndex == cellIndex
    }
}
