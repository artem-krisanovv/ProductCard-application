import Foundation

struct CellModel {
    let name: String
    let price: Double
    
    static func mockData() -> [CellModel] {
        [
            CellModel(name: "Amazing Shoes", price: 11.0),
            CellModel(name: "Fabulous Pants", price: 15.0),
            CellModel(name: "Fantastic Shoes", price: 16.0),
            CellModel(name: "Spectacular Jacket", price: 12.2),
            CellModel(name: "Stunning Shoes", price: 15.2),
            CellModel(name: "Wonderful Footwear", price: 15.3),
            CellModel(name: "Amazing Footwear", price: 12.9),
            CellModel(name: "Fabulous Footwear", price: 9.0),
            CellModel(name: "Fantastic Footwear", price: 15.67),
            CellModel(name: "Spectacular Pants", price: 12.3),
            CellModel(name: "Stunning Shoes", price: 15.01),
            CellModel(name: "Wonderful Shoes", price: 15.99),
            CellModel(name: "Amazing Jacket", price: 12.456),
            CellModel(name: "Fabulous Jacket", price: 19.0),
            CellModel(name: "Fantastic Jacket", price: 18.0),
            CellModel(name: "Spectacular Shoes", price: 13.0),
            CellModel(name: "Stunning Shoes", price: 17.0),
            CellModel(name: "Wonderful Pants", price: 16.0),
            CellModel(name: "Amazing Pants", price: 16.1),
            CellModel(name: "Fabulous Pants", price: 16.99),
            CellModel(name: "Fantastic Pants", price: 9.01),
            CellModel(name: "Spectacular Panamas", price: 12.228),
            CellModel(name: "Stunning Panamas", price: 11.99),
            CellModel(name: "Wonderful Panamas", price: 15.77)
        ]
    }
}
