class GameID{
    
    init(){

    }

    public func createID(board: Board) -> Int{
        let gameID = Int.random(in: 1 ... 362880)
        return gameID       
    }
}
