class Column : Group{
    func getBoxIndex (columnIndex: Int, cellIndex: Int) -> Int{
        let firstColumnNumbers = [0, 3, 6]
        let secondColumnNumbers = [1, 4, 7]
        let thirdColumnNumbers = [2, 5, 8]
        
        let cellInBox = firstColumnNumbers.contains(cellIndex) ? 0 : secondColumnNumbers.contains(cellIndex) ? 1 : thirdColumnNumbers.contains(cellIndex) ? 2 : -1
        let columnAdder =  firstColumnNumbers.contains(columnIndex) ? 0 : secondColumnNumbers.contains(columnIndex) ? 3 : thirdColumnNumbers.contains(columnIndex) ? 6 : -1

        if (cellInBox < 0 || columnAdder < 0) { fatalError("🤷")}
        
        return cellInBox + columnAdder
    }
}
