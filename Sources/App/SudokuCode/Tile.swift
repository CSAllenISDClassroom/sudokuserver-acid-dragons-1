public class Tile {
    
    private var num : Int? //Creating a new number variable to represent the number in a tile on the sudoku board
    private var mutable : Bool
    
    public init (num: Int?, isMutable: Bool) {
        self.num = num //Initializing the variables
        mutable = isMutable
    }

    //Function to get the number of the tile 
    
    public func getNumber () -> Int? {
        return num
    }

    //Function to remove the number of the tile
    
    public func removeNumber () {
        num = nil
    }

    public func setNumber (num: Int?){
        self.num = num
    }

    //Function that checks if number is mutable on board
    
    public func isMutable () -> Bool {
        return mutable
    }

    //If number on board is 0, it will replace it with a dash to signify an empty slot on the board
    
    public func getNumberString () -> String{
        if (num == nil) {return "-"}
        return String(num!)
    }
}
