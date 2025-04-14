import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ShoppingCategory.name, ascending: true)],
        animation: .default)
    private var categories: FetchedResults<ShoppingCategory>
    
    @State private var showingAddItemView = false
    @State private var totalBeforeTax: Float = 0.0
    @State private var totalAfterTax: Float = 0.0
    @State private var taxRate: Float = 0.13
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        showingAddItemView = true
                    }) {
                        HStack {
                            Text("New Item")
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal)
                }
                
                List {
                    Section("Categories") {
                        ForEach(categories, id: \.self) { category in
                            NavigationLink(destination: CategoryDetailView(category: category)) {
                                Text(category.name ?? "Unknown")
                            }
                        }
                    }
                }
                
                // Tax calculation display
                VStack(alignment: .leading, spacing: 5) {
                    Text("Cost Before Taxes: \(String(format: "$%.2f", totalBeforeTax))")
                        .font(.subheadline)
                    Text("Cost After Taxes: \(String(format: "$%.2f", totalAfterTax))")
                        .font(.subheadline)
                        .bold()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.bottom)
                .onAppear {
                    calculateTotals()
                }
            }
            .sheet(isPresented: $showingAddItemView) {
                AddItemView()
            }
            .navigationTitle("Shopping List")
        }
    }
    
    private func calculateTotals() {
        totalBeforeTax = 0
        
        for category in categories {
            if let items = category.items as? Set<ShoppingItem> {
                for item in items {
                    totalBeforeTax += item.price * Float(item.quantity)
                }
            }
        }
        
        totalAfterTax = totalBeforeTax * (1 + taxRate)
    }
}

struct CategoryDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    let category: ShoppingCategory
    
    @State private var totalBeforeTax: Float = 0.0
    @State private var totalAfterTax: Float = 0.0
    @State private var taxRate: Float = 0.13
    @State private var showingDeleteConfirmation = false
    @State private var itemToDelete: ShoppingItem?
    
    var body: some View {
        VStack {
            List {
                if let items = category.items as? Set<ShoppingItem> {
                    ForEach(Array(items), id: \.self) { item in
                        HStack {
                            Text(item.name ?? "Unknown")
                            Spacer()
                            Text("x\(item.quantity)")
                            Text(String(format: "$%.2f", item.price * Float(item.quantity)))
                        }
                        .contentShape(Rectangle())
                        .onLongPressGesture {
                            itemToDelete = item
                            showingDeleteConfirmation = true
                        }
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Cost Before Taxes: \(String(format: "$%.2f", totalBeforeTax))")
                    .font(.subheadline)
                Text("Cost After Taxes: \(String(format: "$%.2f", totalAfterTax))")
                    .font(.subheadline)
                    .bold()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.bottom)
            .onAppear {
                calculateTotals()
            }
        }
        .navigationTitle(category.name ?? "Category")
        .alert("Delete Item", isPresented: $showingDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                if let item = itemToDelete {
                    deleteItem(item)
                }
                itemToDelete = nil
            }
            Button("Cancel", role: .cancel) {
                itemToDelete = nil
            }
        } message: {
            if let item = itemToDelete {
                Text("Are you sure you want to delete '\(item.name ?? "this item")'?")
            } else {
                Text("Are you sure you want to delete this item?")
            }
        }
    }
    
    private func calculateTotals() {
        totalBeforeTax = 0
        
        if let items = category.items as? Set<ShoppingItem> {
            for item in items {
                totalBeforeTax += item.price * Float(item.quantity)
            }
        }
        
        totalAfterTax = totalBeforeTax * (1 + taxRate)
    }
    
    private func deleteItem(_ item: ShoppingItem) {
        viewContext.delete(item)
        
        do {
            try viewContext.save()
            calculateTotals()
        } catch {
            print("Error deleting item: \(error)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
