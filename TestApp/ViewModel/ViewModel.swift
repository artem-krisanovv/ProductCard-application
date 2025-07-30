import Foundation

class ViewModel {
    
    var cellList: [CellModel] = []
    private var originalData: [CellModel] = []
    private var isFiltered = false
    
    var onUpdate: (() -> Void)?
    var searchHistory: [String] = ["Shoes", "Pants", "Footwear", "Panamas"]
    
    // MARK: - Init
    
    init() {
        originalData = CellModel.mockData()
        cellList = originalData
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
    
    // MARK: Searh History Method
    
    func filterProducts(with query: String, forceFilter: Bool = false) {
        if query.count >= 3 || forceFilter {
            cellList = originalData.filter { product in
                product.name.lowercased().contains(query.lowercased())
            }
            isFiltered = true
        } else {
            showAllProducts()
        }
        onUpdate?()
    }
    
    func showAllProducts() {
        cellList = originalData
        isFiltered = false
        onUpdate?()
    }
    
    func addToSearchHistory(_ query: String) {
        searchHistory.removeAll { $0 == query }
        searchHistory.insert(query, at: 0)
        if searchHistory.count > 10 {
            searchHistory = Array(searchHistory.prefix(10))
        }
    }
}
