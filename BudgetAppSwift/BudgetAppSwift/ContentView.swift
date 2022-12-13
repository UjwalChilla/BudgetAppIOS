//
//  ContentView.swift
//  BudgetAppSwift
//
//  Created by Ujwal Chilla on 12/14/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var username: String = ""
    @State private var nameOfObject: String = ""
    @State private var priceTextBoxValue: String = ""
    @State private var weeksTextBoxValue: String = ""
    
    @State private var showingMainScreen = false
    
    @State private var 🤑 = 0
    @State private var weeks = 0
    
    var body: some View {
        
        NavigationView{
        
            VStack(spacing: 30.0){
            
                Text("Savings App")
                    .font(.title)
                
                Spacer()
            
                Text("What's your name?").id("nameTextBox")
            
                TextField("Name", text: $username).padding()
            
                Text("Name of object")
            
                TextField("Object Name", text: $nameOfObject).padding()
                
                Text("Price of your object")
                
                TextField("Price", text: $priceTextBoxValue).keyboardType(.numberPad).padding()
                
                VStack(spacing: 30.0){
                
                    Text("Length of Savings Period")
                
                    TextField("Number of weeks", text:  $weeksTextBoxValue).keyboardType(.numberPad).padding()
                    
                    Button(action: {
                
                        withAnimation{
                    
                            showingMainScreen.toggle()
                            🤑 = Int(priceTextBoxValue)!
                            weeks = Int(weeksTextBoxValue)!
                     
                        }
                    
                    }) {
                    
                        Text("Save Info")
                    
                    }.padding().buttonStyle(.borderedProminent)
                
                    
                    if showingMainScreen{
                        
                        NavigationLink(destination: MainScreenView(username: username,objectName: nameOfObject, price: 🤑, weeks: weeks), label:{
                        
                            Text("Go").font(.title)
                        
                        })
                        
                    }
                    
                }
            
            }
            
        }
        
    }
    
}

private var savedAmt = 0

struct MainScreenView: View{
    
    let username: String
    let objectName: String
    let price: Int
    let weeks: Int
    
    @State private var progress = 0
    @State private var amtSaved = 0
    @State private var showingSavingsView = false
    
    @Environment(\.dismiss) var dismiss
    
    @State private var selectionExpenseSaving = "Choose"
    @State private var selectionExpenseCatagory = "Choose"
    @State private var saved = "0"
    @State private var spent = "0"

    let options = ["Choose", "Saving", "Expense"]
    let catagoryOptions = ["Choose", "Recreation", "Food", "Repairs", "Transportation", "Subsciptions", "Insurance"]
    
    @State private var expenses = [Expenditure(name: "List of expenditures:")]
    
    var body: some View{
        
        VStack(){
            
            Text("Hi, \(username)! Track Your Savings Here")
                .font(.title)
            
            Spacer()
            
            Text("Suggested average savings/week: $\(price/weeks)/week")
            
            VStack(){
                
                ZStack(alignment: .leading){
                
                    Rectangle().foregroundColor(Color(.secondarySystemBackground)).frame(width: 300, height: 24).cornerRadius(8)
                
                    LinearGradient(gradient: Gradient(colors: [
                    
                        progress < 300 ? .orange : Color(.systemTeal),
                        progress < 300 ? .pink : .blue
                    
                        ]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/).frame(width: CGFloat(progress), height: 24).cornerRadius(8)
                
                }.padding(.bottom)
            
                HStack(){
                
                    Text(progress < 300 ? "$\(amtSaved) out of $\(price) saved" : "COMPLETE").bold()
                
                    Spacer()
                
                    Text(progress < 300 ? "\((Double(amtSaved) / Double(price)) * 100)%" : "Go ahead an buy your \(objectName)!")
                    
                }
            
            
            }.frame(width: 272)
            
            VStack(){
                
                Button(action: {
        
                    if self.progress < 300 {
                    
                        self.progress += Int(300*(Double(savedAmt)/Double(price)))
                        self.amtSaved += savedAmt
                    
                    }
            
                }) {
            
                    Text("Refresh")
            
                }.padding()
                
                Spacer()
                
                Text("Expenditures").font(.title)
                
                List(expenses) {expenditure in
                    
                    expenditureList(expenditure: expenditure)
                    
                }
            
                Button(action: {
        
                    showingSavingsView.toggle()
            
                }) {
            
                    Text("Add Savings/Expenses")
            
                }.sheet(isPresented: $showingSavingsView){
                
                    Text("Log Savings/Expenses").font(.title)
                
                    Spacer()
                
                    NavigationView {
                      
                        Form {
                    
                            Section {
                        
                                Picker("Saving/Expense", selection: $selectionExpenseSaving) {
                            
                                    ForEach(options, id: \.self) {
                                
                                        Text($0)
                                    
                                    }
                                
                                }
                            
                            }
                        
                            if selectionExpenseSaving == "Saving"{
                            
                                Section(header: Text("Log savings")){
                                    
                                    TextField("Amount Saved", text: $saved)
                                    
                                }
                            
                            }
                            else{
                                
                                Section(header: Text("Log expenses")){
                                
                                    Picker("Catagories", selection: $selectionExpenseCatagory) {
                                
                                        ForEach(catagoryOptions, id: \.self) {
                                    
                                            Text($0)
                                        
                                        }
                                    
                                    }
                                
                                    TextField("Amount Spent", text: $spent)
                                
                                }
                            
                            }
                            
                        }
                        
                    }
                            
                    Button("Save"){
                    
                        savedAmt = Int(saved)! - Int(spent)!
                        
                        saved = "0"
                        spent = "0"
                        expenses.append(Expenditure(name: savedAmt >= 0 ? "New Saving: $\(savedAmt)" : "New Expense: $\(savedAmt)"))
                        
                    }
                
                }.padding().buttonStyle(.borderedProminent)
                
            }
            
        }
        
    }
    
}

struct Expenditure: Identifiable{
    
    var id = UUID()
    var name: String
    
}

struct expenditureList: View{
    
    var expenditure: Expenditure
    
    var body: some View{
        
        Text("\(expenditure.name)")
        
    }
    
}

struct PieChartView: View{
    
    var body: some View{
    
        Text("Hello")
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
