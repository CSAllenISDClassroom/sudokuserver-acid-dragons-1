import Vapor

func routes(_ app: Application) throws {
    let partialBoard = Board(boardMode: BoardMode.superEasy)
    let gameID = GameID()
    
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return("Hello, world!")
    }

    app.post("game") { req -> String in
        let response = ("Status Code 201 Created" + "\n" + String(gameID.createID(board: partialBoard)))
        return response
    }


    app.get("game", ":id") { req -> String in
        // let partialBoard = Board(boardMode: BoardMode.superEasy)
        // let gameID = GameID()

        let _ = req.parameters.get("id")!
        //return partialBoard.getBoardString()

        let response = ("Status Code 200 OK" + "\n" + partialBoard.getBoardString())
        
        return response

        
                                          
    }


    // app.get("gamesupereasy") { req in
    //     let partialBoard = Board(boardMode: BoardMode.superEasy)
    //     let gameID = GameID()
    //     let json = JSON()
    //     try json.set(String(gameID.createID(board: partialBoard)))
    //     return json
    // }

    app.get("gameeasy") { req -> String in
        let partialBoard = Board(boardMode: BoardMode.easy)
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
    }
}
