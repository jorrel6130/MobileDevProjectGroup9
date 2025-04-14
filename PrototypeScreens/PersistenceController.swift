import CoreData

class PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "PrototypeScreens")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        
        createSampleDataIfNeeded()
    }
    
    private func createSampleDataIfNeeded() {
        let context = container.viewContext
        
        let fetchRequest: NSFetchRequest<ShoppingCategory> = ShoppingCategory.fetchRequest()
        do {
            let count = try context.count(for: fetchRequest)
            if count > 0 { return }
        } catch {
            print("Error checking for existing data: \(error)")
            return
        }
        
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
        
        let medication = ShoppingCategory(context: context)
        medication.id = UUID()
        medication.name = "Medication"
        
        let medItem = ShoppingItem(context: context)
        medItem.id = UUID()
        medItem.name = "Medication Stuff"
        medItem.price = 10.00
        medItem.quantity = 1
        medItem.category = medication
        
        do {
            try context.save()
        } catch {
            print("Error creating sample data: \(error)")
        }
    }
}
