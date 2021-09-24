import Vapor

func routes(_ app: Application) throws {
    var runningGames = [Int: Board]()

    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return("Hello, world!")
    }
    
    app.post("games") {req -> [String : String] in 
         let partialBoard = Board(boardDifficulty: BoardDifficulty.superEasy)
        let gameID = GameID.createID(runningGames: runningGames)
        runningGames[gameID] = partialBoard
        
        return ["id" : String(gameID)]
        }


    app.get("games", ":id", "cells") { req -> String in
        guard let id = req.parameters.get("id"),
            let integerId = Int(id) else {
            return "Bad Request"//Response(status: .badRequest)
        }   
        guard let partialBoard = runningGames[integerId] else {
            return "Cannot find board with given ID"//Response(status: .badRequest, body: "Cannot find board with given id")
        }
        return partialBoard.getBoardString()
    }

    app.put("games", ":id", "cells", ":boxIndex", ":cellIndex") {req -> Response in
        guard let id = req.parameters.get("id"),
              let intId = Int(id),
              let boxIndex = req.parameters.get("boxIndex"),
              let boxIndexInt = Int(boxIndex),
              let cellIndex = req.parameters.get("cellIndex"),
              let cellIndexInt = Int(cellIndex) else {
            return Response(status: .badRequest)
        }
        
        guard let partialBoard = runningGames[intId] else {
            return Response(status: .badRequest, body: "Cannot find board with given id")
        }
        
        var num : Int?
        if let numString = req.body.string {

            if Int(numString) == nil {
                return Response(status: .badRequest, body: "Ensure that you pass an integer in the request body")
            }
            else {
                num = Int(numString)
                if (num! < 1 || num! > 9) {
                    return Response(status: .badRequest, body: "Ensure that the inputted number is in between 1-9")
                }
            }
        } else {
            num = nil
        }

        guard (partialBoard.canAlterTile(boxIndex: boxIndexInt, cellIndex: cellIndexInt)) else {
            return Response(status: .unauthorized, body: "That tile is immutable")
        }

        runningGames[intId] = partialBoard.alterBoard(num: num, boxIndex: boxIndexInt, cellIndex: cellIndexInt)
        return Response(status: .noContent, body: "")
    }
}
