public class Tile {
    
    private var num : Int //Creating a new number variable to represent the number in a tile on the sudoku board
 
    public init (num: Int) {
        
        self.num = num //Initializing the variables
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

    public func getNumberString () -> String{
        if (num == 0) {return "-"}
        return String(num)
    }
}
