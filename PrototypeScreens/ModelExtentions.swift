import Foundation
import CoreData

extension ShoppingCategory {
    var itemsArray: [ShoppingItem] {
        let itemSet = items as? Set<ShoppingItem> ?? []
        return itemSet.sorted { ($0.name ?? "") < ($1.name ?? "") }
    }
    
    func calculateTotal() -> Float {
        let itemsArr = itemsArray
        return itemsArr.reduce(0) { $0 + ($1.price * Float($1.quantity)) }
    }
}

extension ShoppingItem {
    var total: Float {
        return price * Float(quantity)
    }
}
