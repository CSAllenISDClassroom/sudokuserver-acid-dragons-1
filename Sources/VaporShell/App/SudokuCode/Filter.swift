public enum Filter{
    case all
    case repeated
    case incorrect  
}

public func getFilterFromString(filterString: String) -> Filter? {
    switch (filterString) {
    case "all":
        return Filter.all
    case "repeated":
        return Filter.repeated
    case "incorrect":
        return Filter.incorrect
    default:
        return nil
    }
}

public func shouldShowNilBoardCodable(filter: Filter) -> Bool {
    return filter == Filter.all
}
