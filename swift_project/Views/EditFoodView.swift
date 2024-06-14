//
//  EditFoodView.swift
//  swift_project
//
//  Created by przet on 08/06/2024.
//

import SwiftUI

struct EditFoodView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    var food: FetchedResults<Food>.Element
    
    @State private var name = ""
    @State private var carbs: Double = 0
    @State private var fat: Double = 0
    @State private var protein: Double = 0
    
    var body: some View {
        Form {
            Section {
                TextField("\(food.name!)", text: $name)
                    .onAppear {
                        name = food.name!
                        carbs = food.carbs
                        fat = food.fat
                        protein = food.protein
                    }
                VStack {
                    Text("Carbs: \(carbs, specifier: "%.2f") g")
                    Slider(value: $carbs, in: 0...100, step: 1)
                }
                .padding()
                
                VStack {
                    Text("Fat: \(fat, specifier: "%.2f") g")
                    Slider(value: $fat, in: 0...100, step: 1)
                }
                .padding()
                
                VStack {
                    Text("Protein: \(protein, specifier: "%.2f") g")
                    Slider(value: $protein, in: 0...100, step: 1)
                }
                .padding()
                
                HStack {
                    Spacer()
                    Button("Submit"){
                        DataController().editFood(food: food, name: name, carbs: carbs, fat: fat, protein: protein, context: managedObjContext)
                        dismiss()
                    }
                    Spacer()
                }
            }
        }
    }
}

struct EditFoodView_Previews: PreviewProvider {
    static var previews: some View {
        EditFoodView(food: Food())
    }
}