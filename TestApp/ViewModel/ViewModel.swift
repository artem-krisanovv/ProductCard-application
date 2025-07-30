import Foundation

class ViewModel {
    
    private var cellList: [CellModel] = []
    var onUpdate: (() -> Void)?
    var searchHistory: [String] = ["Shoes", "T-shirt", "Jeans", "Hat"]
    
    // MARK: - Init
    
    init() {
        cellList = CellModel.mockData()
    }
    
    // MARK: - Data Access
    
    var data: [CellModel] {
        return cellList
    }
    
    // MARK: - Sort Func
    
    enum Sort {
        case priceAsc
        case priceDesc
    }
    
    func sort(by order: Sort) {
        switch order {
        case .priceAsc:
            cellList.sort { $0.price < $1.price }
        case .priceDesc:
            cellList.sort { $0.price > $1.price }
        }
        onUpdate?()
    }
}
