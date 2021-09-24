class GameID{

    init () {

    }
    
    private static func generateRandomInt() -> Int {
        return Int.random(in: 1 ... Int.max)
    }
    
    public static func createID(runningGames: [Int:Board]) -> Int{
        var curIDs = [Int]()
        for (curID, _) in runningGames {
            curIDs.append(curID)
        }

        var id = generateRandomInt()
        
        while curIDs.contains(id) {
            id = generateRandomInt()
        }
        
        return id
    }

    public static func checkID(runningGames: [Int:Board], idToCheck: Int) -> Bool {
        for (curID, _) in runningGames {
            if curID == idToCheck {return true}
        }

        return false
    }
}
