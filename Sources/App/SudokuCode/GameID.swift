class GameID{
    
    init(){

    }

    public static func createID() -> Int{
        return Int.random(in: 1 ... 362880)
    }
}
