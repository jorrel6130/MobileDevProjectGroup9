import SwiftUI
import CoreData

struct AddItemView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ShoppingCategory.name, ascending: true)],
        animation: .default)
    private var categories: FetchedResults<ShoppingCategory>
    
    @State private var name: String = ""
    @State private var price: String = ""
    @State private var amount: Int = 1
    @State private var selectedCategory: ShoppingCategory?
    
    var priceValue: Float? {
        return Float(price.replacingOccurrences(of: ",", with: "."))
    }
    
    var isFormValid: Bool {
        return !name.isEmpty && priceValue != nil && priceValue! > 0 && selectedCategory != nil
    }
    
    var costBeforeTaxes: Float {
        return (priceValue ?? 0) * Float(amount)
    }
    
    var costAfterTaxes: Float {
        return costBeforeTaxes * 1.13
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("New Item")
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Name")
                        .font(.headline)
                        .bold()
                        .padding(.leading)
                    TextField("Enter name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Price")
                        .font(.headline)
                        .bold()
                        .padding(.leading)
                    TextField("Enter price", text: $price)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Category")
                        .font(.headline)
                        .bold()
                        .padding(.leading)
                    
                    if categories.isEmpty {
                        Text("No categories available")
                            .italic()
                            .padding(.horizontal)
                    } else {
                        Picker("Select a category", selection: $selectedCategory) {
                            Text("Select a category").tag(nil as ShoppingCategory?)
                            ForEach(categories, id: \.self) { category in
                                Text(category.name ?? "Unknown").tag(category as ShoppingCategory?)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.horizontal)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack {
                    Text("Amount")
                        .font(.headline)
                        .bold()
                    HStack {
                        Button(action: {
                            if amount > 1 {
                                amount -= 1
                            }
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .font(.title)
                                .foregroundColor(.black)
                        }
                        
                        Text("\(amount)")
                            .font(.title)
                            .frame(width: 70, height: 50)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                        
                        Button(action: {
                            amount += 1
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                                .foregroundColor(.black)
                        }
                    }
                }
                
                Button(action: saveItem) {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFormValid ? Color.blue : Color.gray.opacity(0.5))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .disabled(!isFormValid)
                // summary section
                VStack(alignment: .leading, spacing: 5) {
                    Text("Cost Before Taxes: \(String(format: "$%.2f", costBeforeTaxes))")
                    Text("Cost After Taxes: \(String(format: "$%.2f", costAfterTaxes))")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top)
            .background(Color(UIColor.systemGray6))
            .navigationBarTitle("New Item", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func saveItem() {
        guard let category = selectedCategory, let validPrice = priceValue else { return }
        
        let newItem = ShoppingItem(context: viewContext)
        newItem.id = UUID()
        newItem.name = name
        newItem.price = validPrice
        newItem.quantity = Int16(amount)
        newItem.category = category
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Error saving item: \(error)")
        }
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView()
    }
}
