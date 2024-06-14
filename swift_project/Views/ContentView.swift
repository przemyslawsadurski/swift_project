//
//  ContentView.swift
//  swift_project
//
//  Created by przet on 08/06/2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var food: FetchedResults<Food>
    
    @State private var showingAddView = false
    @State private var showingDetailView = false
    @State private var showingEditView = false
    @State private var showingDaySummaryView = false
    @State private var selectedFood: Food?
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("\(Int(totalCaloriesToday())) Kcal (Today)")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                List {
                    ForEach(food) { food in
                        HStack {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(food.name!)
                                    .bold()
                                Text("\(calculateCalories(for: food), specifier: "%.0f") calories").foregroundColor(.red)
                            }
                            Spacer()
                            Text(calcTimeSince(date: food.date!))
                                .foregroundColor(.gray)
                                .italic()
                        }
                        .onTapGesture(count: 2) {
                            selectedFood = food
                            showingDetailView.toggle()
                        }
                        .onLongPressGesture {
                            selectedFood = food
                            showingEditView.toggle()
                        }
                    }
                    .onDelete(perform: deleteFood)
                }
                .listStyle(.plain)
            }
            .navigationTitle("DietReminder")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddView.toggle()
                    } label: {
                        Label("Add Food", systemImage: "plus.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        showingDaySummaryView.toggle()
                    } label: {
                        Label("Day Summary", systemImage: "calendar")
                    }
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddFoodView()
            }
            .sheet(isPresented: $showingDetailView) {
                if let selectedFood = selectedFood {
                    FoodDetailView(food: selectedFood)
                }
            }
            .sheet(isPresented: $showingEditView) {
                if let selectedFood = selectedFood {
                    EditFoodView(food: selectedFood)
                }
            }
            .sheet(isPresented: $showingDaySummaryView) {
                DaySummaryView().environment(\.managedObjectContext, managedObjContext)
            }
        }
        .navigationViewStyle(.stack)
    }
    
    private func deleteFood(offsets: IndexSet) {
        withAnimation {
            offsets.map { food[$0] }.forEach(managedObjContext.delete)
            
            DataController().save(context: managedObjContext)
        }
    }
    
    private func totalCaloriesToday() -> Double {
        return food.filter { Calendar.current.isDateInToday($0.date!) }
            .reduce(0) { $0 + calculateCalories(for: $1) }
    }
    
    private func calculateCalories(for food: Food) -> Double {
        let carbsCalories = food.carbs * 4
        let fatCalories = food.fat * 9
        let proteinCalories = food.protein * 4
        return carbsCalories + fatCalories + proteinCalories
    }
    
    private func calcTimeSince(date: Date) -> String {
        let minutes = Int(-date.timeIntervalSinceNow) / 60
        let hours = minutes / 60
        let days = hours / 24
        
        if minutes < 120 {
            return "\(minutes) minutes ago"
        } else if minutes >= 120 && hours < 48 {
            return "\(hours) hours ago"
        } else {
            return "\(days) days ago"
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}






