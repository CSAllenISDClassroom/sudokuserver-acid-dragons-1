import Vapor
import Foundation


let partialBoard = Board(boardMode: BoardMode.superEasy)

struct ID : Codable {
    let id : Int
}

struct UserInput : Codable {
    let value : Int
}

func routes(_ app: Application) throws {
    var runningGames = [Int: Board]()

    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return("Hello, world!")
    }
    
    app.post("games") {req -> String in
        guard let difficulty = req.query[String.self, at: "difficulty"] else {
            return "Parameter difficulty required"
        }
        
        let partialBoard = Board(boardDifficulty: difficulty)
        let gameID = GameID.createID(runningGames: runningGames) //Server is creating a Game Id
        runningGames[gameID] = partialBoard
        
        let id = ID(id: gameID)
        let encoder = JSONEncoder()
        
        guard let data = try? encoder.encode(id),
              let string = String(data: data, encoding: .utf8) else {
            fatalError("Failed to encode ID to JSON")
        } 
        
        return string
    }



    app.get("boardeasy") { req -> String in
        return partialBoard.getBoardString()
    }
    app.get("games", ":id", "cells") { req -> String in
        guard let id = req.parameters.get("id"), //client will later use to retrieve the running partial board
            let integerId = Int(id) else {
            return "Bad Request"//Response(status: .badRequest)
        }   
        guard let partialBoard = runningGames[integerId] else {
            return "Cannot find board with given ID"//Response(status: .badRequest, body: "Cannot find board with given id")
        }

        let boardCodable = BoardCodable(board: partialBoard)
        let encoder = JSONEncoder()
        
        guard let data = try? encoder.encode(boardCodable),
              let string = String(data: data, encoding: .utf8) else {
            fatalError("Failed to encode Board to JSON")
        } 
        
        return string
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

        guard ((boxIndexInt >= 0 && boxIndexInt < 9) && (cellIndexInt >= 0 && cellIndexInt < 9)) else {
            return Response(status: .badRequest, body: "Please Provide a valud box and cell index")
        }
        
        guard let partialBoard = runningGames[intId] else {
            return Response(status: .badRequest, body: "Cannot find board with given id")
        }
        
        var num : Int?
        if let userInput = req.body.string {
            let jsonData = userInput.data(using: .utf8)!

            guard let value : Int? = try JSONDecoder().decode(UserInput.self, from: jsonData).value else {
                return Response(status: .badRequest)
            }

            guard let unwrappedVal = value else {
                return Response(status: .badRequest, body: "Ensure that you pass an integer in the request body")
            }
            
            guard (unwrappedVal > 0 && unwrappedVal < 10) else {
                return Response(status: .badRequest, body: "Ensure that the inputted number is in between 1-9")
            }
            
            num = unwrappedVal
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
