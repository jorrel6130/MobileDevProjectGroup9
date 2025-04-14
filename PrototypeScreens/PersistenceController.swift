import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ShoppingList")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error loading Core Data stores: \(error.localizedDescription)")
            }
        }
    }
    
    func createSampleData() {
        let context = container.viewContext
        
        // Check if we already have data
        let fetchRequest: NSFetchRequest<ShoppingCategory> = ShoppingCategory.fetchRequest()
        do {
            let count = try context.count(for: fetchRequest)
            if count > 0 { return }
        } catch {
            print("Error checking for existing data: \(error)")
        }
        
        // Create categories and items
        let foodCategory = ShoppingCategory(context: context)
        foodCategory.id = UUID()
        foodCategory.name = "Food"
        
        let milk = ShoppingItem(context: context)
        milk.id = UUID()
        milk.name = "Milk"
        milk.price = 2.00
        milk.quantity = 1
        milk.category = foodCategory
        
        let eggs = ShoppingItem(context: context)
        eggs.id = UUID()
        eggs.name = "Eggs"
        eggs.price = 2.00
        eggs.quantity = 3
        eggs.category = foodCategory
        
        let bacon = ShoppingItem(context: context)
        bacon.id = UUID()
        bacon.name = "Bacon"
        bacon.price = 2.00
        bacon.quantity = 2
        bacon.category = foodCategory
        
        let pasta = ShoppingItem(context: context)
        pasta.id = UUID()
        pasta.name = "Pasta"
        pasta.price = 3.00
        pasta.quantity = 1
        pasta.category = foodCategory
        
        let bread = ShoppingItem(context: context)
        bread.id = UUID()
        bread.name = "Bread"
        bread.price = 2.00
        bread.quantity = 4
        bread.category = foodCategory
        
        // Medication category
        let medCategory = ShoppingCategory(context: context)
        medCategory.id = UUID()
        medCategory.name = "Medication"
        
        let medItem = ShoppingItem(context: context)
        medItem.id = UUID()
        medItem.name = "Medication Stuff"
        medItem.price = 10.00
        medItem.quantity = 1
        medItem.category = medCategory
        
        // Cleaning category
        let cleaningCategory = ShoppingCategory(context: context)
        cleaningCategory.id = UUID()
        cleaningCategory.name = "Cleaning Products"
        
        let cleaningItem = ShoppingItem(context: context)
        cleaningItem.id = UUID()
        cleaningItem.name = "Cleaning Stuff"
        cleaningItem.price = 4.30
        cleaningItem.quantity = 1
        cleaningItem.category = cleaningCategory
        
        // Misc category
        let miscCategory = ShoppingCategory(context: context)
        miscCategory.id = UUID()
        miscCategory.name = "Misc"
        
        let miscItem = ShoppingItem(context: context)
        miscItem.id = UUID()
        miscItem.name = "Misc Stuff"
        miscItem.price = 8.30
        miscItem.quantity = 1
        miscItem.category = miscCategory
        
        // Save changes
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}