public class Row : Group{
    func getBoxIndex (rowIndex: Int, cellIndex: Int) -> Int {
        let cellInRow = cellIndex < 3 ? 0 : cellIndex < 6 ? 1 : cellIndex < 9 ? 2 : -1
        let rowAdder = rowIndex < 3 ? 0 : rowIndex < 6 ? 3 : rowIndex < 9 ? 6 : -1

        if (cellInRow < 0 || rowAdder < 0) { fatalError("🤷")}
        
        return cellInRow + rowAdder
    }
}
