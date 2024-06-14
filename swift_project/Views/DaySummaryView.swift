//
//  DaySummaryView.swift
//  swift_project
//
//  Created by przet on 08/06/2024.
//

import SwiftUI
import CoreData

struct DaySummaryView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    
    @State private var selectedDate = Date()
    @State private var foods: [Food] = []
    
    private var startOfDay: Date {
        Calendar.current.startOfDay(for: selectedDate)
    }
    
    private var endOfDay: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Summary for \(formattedDate(selectedDate))")
                .font(.largeTitle)
                .padding(.bottom, 20)
            
            DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
                .onChange(of: selectedDate) { _ in
                    updateFetchRequest()
                }
            
            Text("Total Calories: \(totalCalories(), specifier: "%.0f")")
            
            List {
                ForEach(foods) { food in
                    VStack(alignment: .leading) {
                        Text(food.name!)
                            .font(.headline)
                        Text("Calories: \(calculateCalories(for: food), specifier: "%.0f")")
                        Text("Time: \(formatDate(food.date!))")
                    }
                }
            }
        }
        .padding()
        .onAppear(perform: updateFetchRequest)
    }
    
    private func totalCalories() -> Double {
        return foods.reduce(0) { $0 + calculateCalories(for: $1) }
    }
    
    private func calculateCalories(for food: Food) -> Double {
        let carbsCalories = food.carbs * 4
        let fatCalories = food.fat * 9
        let proteinCalories = food.protein * 4
        return carbsCalories + fatCalories + proteinCalories
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func updateFetchRequest() {
        let request: NSFetchRequest<Food> = Food.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Food.date, ascending: false)]
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
        
        do {
            foods = try managedObjContext.fetch(request)
        } catch {
            print("Failed to fetch items: \(error)")
        }
    }
}

struct DaySummaryView_Previews: PreviewProvider {
    static var previews: some View {
        DaySummaryView()
    }
}




