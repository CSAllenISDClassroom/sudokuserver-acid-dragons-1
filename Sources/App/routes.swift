import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }

    app.get("boardsupereasy") { req -> String in
        let partialBoard = Board(boardMode: BoardMode.superEasy)
        return partialBoard.getBoardString()
    }

    app.get("boardeasy") { req -> String in
        let partialBoard = Board(boardMode: BoardMode.easy)
        return partialBoard.getBoardString()
    }
    
    app.get("boardmedium") { req -> String in
        let partialBoard = Board(boardMode: BoardMode.medium)
        return partialBoard.getBoardString()
    }

    app.get("boardhard") { req -> String in
        let partialBoard = Board(boardMode: BoardMode.hard)
        return partialBoard.getBoardString()
    }

    app.get("boardsuperhard") { req -> String in
        let partialBoard = Board(boardMode: BoardMode.superHard)
        return partialBoard.getBoardString()
    }

    app.get("boardimpossible") { req -> String in
        let partialBoard = Board(boardMode: BoardMode.impossible)
        return partialBoard.getBoardString()
    }
}
