//
//  ShoppingItem+CoreDataProperties.swift
//  PrototypeScreens
//
//  Created by ian mcdonald on 2025-04-14.
//
//

import Foundation
import CoreData


extension ShoppingItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShoppingItem> {
        return NSFetchRequest<ShoppingItem>(entityName: "ShoppingItem")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var price: Float
    @NSManaged public var quantity: Int16
    @NSManaged public var category: ShoppingCategory?

}

extension ShoppingItem : Identifiable {

}
