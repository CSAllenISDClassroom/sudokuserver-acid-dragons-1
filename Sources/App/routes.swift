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
        let partialBoard = Board(boardMode: BoardMode.superEasy)
        let gameID = GameID.createID(runningGames: runningGames)
        runningGames[gameID] = partialBoard
        
        return ["id" : String(gameID)]
        }


    app.get("games", ":id", "cells") { req -> [String:String] in
        //        if req.parameters.get("id") != nil && Int(req.parameters.get("id")!) != nil
        guard let id = req.parameters.get("id"),
              let integerId = Int(id) else {
            return HttpResponse.badRequest
        }
        
        
        let id = Int(req.parameters.get("id")!)!

        guard GameID.checkID(runningGames: runningGames, idToCheck: id) else {
            return "Cannot find board with given id"
        }

        let partialBoard = runningGames[id]!
        let response = partialBoard.getBoardString()

        return ["cells:" : response]
    }

    app.put("games", ":id", "cells", ":boxIndex", ":cellIndex") {req -> Response in
        let id = Int(req.parameters.get("id")!)!
        let boxIndex = Int(req.parameters.get("boxIndex")!)!
        let cellIndex = Int(req.parameters.get("cellIndex")!)!
        let partialBoard = runningGames[id]!
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

        if (partialBoard.canAlterTile(boxIndex: boxIndex, cellIndex: cellIndex)) {
            runningGames[id] = partialBoard.alterBoard(num: num, boxIndex: boxIndex, cellIndex: cellIndex)
        } else {
            return Response(status: .unauthorized, body: "That tile is immutable")
        }

        return Response(status: .noContent, body: "")
    }

/*    app.get("gamesupereasy") { req -> String in
        let partialBoard = Board(boardMode: BoardMode.superEasy)
        let gameID = GameID.createID()
        sudokoGame[gameID] = partialBoard
        return String(gameID)
    }

    app.get("gameeasy") { req -> String in
        partialBoard = Board(boardMode: BoardMode.easy)
        let gameID = GameID()
        return String(gameID.createID(board: partialBoard))
    }
    
    app.get("gamemedium") { req -> String in
        let partialBoard = Board(boardMode: BoardMode.medium)
        let gameID = GameID()
        return String(gameID.createID(board: partialBoard))
    }

    app.get("gamehard") { req -> String in
        let partialBoard = Board(boardMode: BoardMode.hard)
        let gameID = GameID()
        return String(gameID.createID(board: partialBoard))
    }

    app.get("gamesuperhard") { req -> String in
        let partialBoard = Board(boardMode: BoardMode.superHard)
        let gameID = GameID()
        return String(gameID.createID(board: partialBoard))
    }

    app.get("gameimpossible") { req -> String in
        let partialBoard = Board(boardMode: BoardMode.impossible)
        let gameID = GameID()
        return String(gameID.createID(board: partialBoard))
    }*/
}
