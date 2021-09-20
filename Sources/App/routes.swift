import Vapor

var runningGames = [Int: Board]() //Keeps track of all the active games currently running

func routes(_ app: Application) throws {
    app.get { req in //Basic get request. Starts when server is running
        return "It works!"
    }

    app.get("hello") { req -> String in //With parameter of hello, a get request will happen
        return("Hello, world!")
    }

    app.post("games") { req -> String in
        let partialBoard = Board(boardMode: BoardMode.superEasy) //Creating a partial board object
        let gameID = GameID.createID() //Creates a game ID object
        runningGames[gameID] = partialBoard //Assigns the partial board to the gameID
        return String(gameID) //Returns the GameID as a string
    }


    app.get("games", ":id", "cells") { req -> String in
        let id = Int(req.parameters.get("id")!)! //Stores the ID parameter in the URL
        let partialBoard = runningGames[id]!
        let response = partialBoard.getBoardString() //Creates the server response to the get request
        
        return response //returns the response
    }

    app.put("games", ":id", "cells", ":boxIndex", ":cellIndex") {req -> String in
        let id = Int(req.parameters.get("id")!)! //Stores the ID parameter giving in URL
        let boxIndex = Int(req.parameters.get("boxIndex")!)! //Stores the Box index parameter given in URL
        let cellIndex = Int(req.parameters.get("cellIndex")!)! //Stores the Cell index parameter given in URL
        let partialBoard = runningGames[id]!

        runningGames[id] = partialBoard.alterBoard(num: 5, boxIndex: boxIndex, cellIndex: cellIndex) //Changes the board based on box index and cell
                                                                                                     //index
        
        return "Worked" //Returns generic server response
    }

    //////////////////////////////////////////////////////////////////////
    //UNUSED CODE
    //////////////////////////////////////////////////////////////////////

    // app.get("gamesupereasy") { req -> String in
    //     let partialBoard = Board(boardMode: BoardMode.superEasy)
    //     let gameID = GameID.createID()
    //     sudokoGame[gameID] = partialBoard
    //     return String(gameID)
    // }

    // app.get("gameeasy") { req -> String in
    //     partialBoard = Board(boardMode: BoardMode.easy)
    //     let gameID = GameID()
    //     return String(gameID.createID(board: partialBoard))
    // }
    
    // app.get("gamemedium") { req -> String in
    //     let partialBoard = Board(boardMode: BoardMode.medium)
    //     let gameID = GameID()
    //     return String(gameID.createID(board: partialBoard))
    // }

    // app.get("gamehard") { req -> String in
    //     let partialBoard = Board(boardMode: BoardMode.hard)
    //     let gameID = GameID()
    //     return String(gameID.createID(board: partialBoard))
    // }

    // app.get("gamesuperhard") { req -> String in
    //     let partialBoard = Board(boardMode: BoardMode.superHard)
    //     let gameID = GameID()
    //     return String(gameID.createID(board: partialBoard))
    // }

    // app.get("gameimpossible") { req -> String in
    //     let partialBoard = Board(boardMode: BoardMode.impossible)
    //     let gameID = GameID()
    //     return String(gameID.createID(board: partialBoard))
    //}
}
