//
//  DataController.swift
//  swift_project
//
//  Created by przet on 08/06/2024.
//

import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "FoodModel")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error loading Core Data. \(error.localizedDescription)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func addFood(name: String, carbs: Double, fat: Double, protein: Double, context: NSManagedObjectContext) {
        let food = Food(context: context)
        food.id = UUID()
        food.date = Date()
        food.name = name
        food.carbs = carbs
        food.fat = fat
        food.protein = protein
        
        save(context: context)
    }
    
    func editFood(food: Food, name: String, carbs: Double, fat: Double, protein: Double, context: NSManagedObjectContext) {
        food.name = name
        food.carbs = carbs
        food.fat = fat
        food.protein = protein
        
        save(context: context)
    }
}

