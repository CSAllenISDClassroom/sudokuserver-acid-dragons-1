import Vapor

var runningGames = [Int: Board]()

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return("Hello, world!")
    }

    app.post("games") { req -> String in
        let partialBoard = Board(boardMode: BoardMode.superEasy)
        let gameID = GameID.createID()
        runningGames[gameID] = partialBoard
        return String(gameID)
    }


    app.get("games", ":id", "cells") { req -> String in
        let id = Int(req.parameters.get("id")!)!
        let partialBoard = runningGames[id]!
        let response = partialBoard.getBoardString()
       
        return response                                     
    }

    app.put("games", ":id", "cells", ":boxIndex", ":cellIndex") {req -> String in
        let id = Int(req.parameters.get("id")!)!
        let boxIndex = Int(req.parameters.get("boxIndex")!)!
        let cellIndex = Int(req.parameters.get("cellIndex")!)!
        let partialBoard = runningGames[id]!
        var num : Int?
        if let numString = req.body.string {

            if Int(numString) == nil {
                return "Ensure that you pass an integer in the request body"
            } 
            else {
                num = Int(numString)
                if (num! < 1 || num! > 9) {
                    return "Ensure that the inputted number is in between 1-9"
                }
            }
        } else {
            num = nil
        }

        if (partialBoard.canAlterTile(boxIndex: boxIndex, cellIndex: cellIndex)) {
            runningGames[id] = partialBoard.alterBoard(num: num, boxIndex: boxIndex, cellIndex: cellIndex)
        } else {
            return "That tile is immutable"
        }
        
        return "Worked"
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
