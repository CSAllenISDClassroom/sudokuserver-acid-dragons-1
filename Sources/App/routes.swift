import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return("Hello, world!")
    }

    app.post("test") { req -> String in
        return("Test works")
    }

    app.get("gamesupereasy") { req -> String in
        let partialBoard = Board(boardMode: BoardMode.superEasy)
        let gameID = GameID()
        return stringGameID            
    }

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
