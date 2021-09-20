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

        runningGames[id] = partialBoard.alterBoard(num: 5, boxIndex: boxIndex, cellIndex: cellIndex)
        
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
