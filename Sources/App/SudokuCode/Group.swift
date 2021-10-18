public class Group  { //Using a class to be able to use inheritance for the Box.swift, Tile.swift, Row.swift, Column.swift instead of repeating code
    private var tiles : [Tile]
    
    public init(tiles: [Tile]) {
        self.tiles = tiles
    }

    public func getTiles () -> [Tile] {
        return tiles
    }

    public func getTile (cellIndex: Int) -> Tile{
        return tiles[cellIndex]
    }
    
    public func setTile (num: Int?, cellIndex: Int) {
        tiles[cellIndex].setNumber(num: num)
    }

    public func removeTile (cellIndex: Int) {
        tiles[cellIndex].removeNumber()
    }
}
