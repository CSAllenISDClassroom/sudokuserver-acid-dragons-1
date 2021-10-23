import Vapor
import Foundation

struct ID : Codable {
    let id : Int
}

struct UserInput : Codable {
    let value : Int
}

//All Routes

func routes(_ app: Application) throws {
    var runningGames = [Int: Board]()

    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return("Hello, world!")
    }

    //Post Request
    
    app.post("games") {req -> Response in
        //Difficulty Parameter
        
        guard let difficulty = req.query[String.self, at: "difficulty"] else {
            return Response(status: .badRequest, body: "Difficulty Parameter required")            
        }

        //In case invalid difficulty chosen
        
        guard let boardDifficulty = Board.getBoardDifficulty(boardDifficulty: difficulty) else{
            return Response(status: .badRequest, body: "400 Bad Request (difficulty specified doesn't match requirements)")
        }
        
        let partialBoard = Board(boardDifficulty: boardDifficulty)
        let gameID = GameID.createID(runningGames: runningGames) //Server is creating a Game Id
        runningGames[gameID] = partialBoard
        
        let id = ID(id: gameID)
        let encoder = JSONEncoder()

        var headers = HTTPHeaders()
        headers.add(name: .contentType, value:"application/json")
        
        guard let data = try? encoder.encode(id),
              let string = String(data: data, encoding: .utf8) else {
            fatalError("Failed to encode ID to JSON")
        } 
        return Response(status: .ok, headers: headers, body: Response.Body(string: string))
    }


    app.get("games", ":id", "cells") { req -> Response in
        guard let id = req.parameters.get("id"), //client will later use to retrieve the running partial board
            let integerId = Int(id) else {
            return Response(status: .badRequest)
        }
        
        guard let partialBoard = runningGames[integerId] else {
            return Response(status: .badRequest, body: "Cannot find board with given id")
        }
        guard let filterString = req.query[String.self, at: "filter"] else {
            return Response(status: .badRequest, body: "Filter parameter required")
        }
        guard let filter = getFilterFromString(filterString: filterString) else {
            return Response(status: .badRequest, body: "Ensure that filter is correctly named")
        }
        
        let filteredBoard = Board.getFilteredBoard(board: partialBoard.board, filter: filter) 
        let boardCodable = BoardCodable(board: filteredBoard, includeNil: shouldShowNilBoardCodable(filter: filter), shouldConvertToBoxes: filter == Filter.all)

        let encoder = JSONEncoder()

        var headers = HTTPHeaders()
        headers.add(name: .contentType, value:"application/json")
                
        guard let data = try? encoder.encode(boardCodable),
              let string = String(data: data, encoding: .utf8) else {
            fatalError("Failed to encode Board to JSON")
        } 
        
        return Response(status: .ok, headers: headers, body: Response.Body(string: string))
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

        //guard statement for incorrect box or cell Index
        guard ((boxIndexInt >= 0 && boxIndexInt < 9) && (cellIndexInt >= 0 && cellIndexInt < 9)) else {
            return Response(status: .badRequest, body: "Please Provide a valid box and cell index. Box Index and Cell index must be between 0-8")
        }

        //Error statement for incorrect ID after Checking array of runningGames ID's to check if requested ID exists
        guard let partialBoard = runningGames[intId] else {
            return Response(status: .badRequest, body: "Cannot find board with given id")
        }
        
        var num : Int?
        if let userInput = req.body.string {
            let jsonData = userInput.data(using: .utf8)!

            let value : Int? = try JSONDecoder().decode(UserInput.self, from: jsonData).value

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
