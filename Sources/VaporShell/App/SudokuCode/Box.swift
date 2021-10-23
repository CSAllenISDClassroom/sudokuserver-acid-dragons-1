public class Box : Group{
    func getRowIndex (boxIndex: Int, cellIndex: Int) -> Int{
        let rowInBox = cellIndex < 3 ? 0 : cellIndex < 6 ? 1 : cellIndex < 9 ? 2 : -1
        let boxAdder = boxIndex < 3 ? 0 : boxIndex < 6 ? 3 : boxIndex < 9 ? 6 : -1

        if (rowInBox < 0 || boxAdder < 0) { fatalError("🤷")}
        
        return rowInBox + boxAdder
    }

    func getColumnIndex (boxIndex: Int, cellIndex: Int) -> Int{
        let firstColumnNumbers = [0, 3, 6]
        let secondColumnNumbers = [1, 4, 7]
        let thirdColumnNumbers = [2, 5, 8]
        
        let columnInBox = firstColumnNumbers.contains(cellIndex) ? 0 : secondColumnNumbers.contains(cellIndex) ? 1 : thirdColumnNumbers.contains(cellIndex) ? 2 : -1
        let boxAdder =  firstColumnNumbers.contains(boxIndex) ? 0 : secondColumnNumbers.contains(boxIndex) ? 3 : thirdColumnNumbers.contains(boxIndex) ? 6 : -1

        if (columnInBox < 0 || boxAdder < 0) { fatalError("🤷")}
        
        return columnInBox + boxAdder
    }
}
