//
//  FoodDetailView.swift
//  swift_project
//
//  Created by przet on 08/06/2024.
//

import SwiftUI
import CoreData

struct FoodDetailView: View {
    var food: Food
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(food.name!)
                .font(.largeTitle)
                .padding(.bottom, 20)
            
            Text("Calories: \(Int(food.calories))")
            Text("Carbs: \(food.carbs, specifier: "%.2f") g")
            Text("Fat: \(food.fat, specifier: "%.2f") g")
            Text("Protein: \(food.protein, specifier: "%.2f") g")
            Text("Consumed on: \(formatDate(food.date!))")
            
            Spacer()
        }
        .padding()
        .navigationTitle("Food Details")
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct FoodDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let food = Food(context: context)
        food.name = "Sample Food"
        food.calories = 320
        food.carbs = 2.0
        food.fat = 8.0
        food.protein = 12.0
        food.date = Date()
        
        return FoodDetailView(food: food)
    }
}


