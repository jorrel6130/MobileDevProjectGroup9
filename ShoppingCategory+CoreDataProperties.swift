import Foundation
import CoreData


extension ShoppingCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShoppingCategory> {
        return NSFetchRequest<ShoppingCategory>(entityName: "ShoppingCategory")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var items: NSSet?

}
typealias CategorySet = NSSet
// MARK: Generated accessors for items
extension ShoppingCategory {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: ShoppingItem)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: ShoppingItem)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

extension ShoppingCategory : Identifiable {

}
