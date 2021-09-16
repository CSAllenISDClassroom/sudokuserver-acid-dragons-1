import Vapor

let partialBoard = Board(boardMode: BoardMode.superEasy)

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }

    app.get("boardeasy") { req -> String in
        return partialBoard.getBoardString()
    }
}
