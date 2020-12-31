//
//  ContentView.swift
//  WeSplit
//
//  Created by ADITHI SU on 31/12/20.
//

    import SwiftUI

    struct ContentView: View {
      @State private var checkAmount = "" //cz default type of Textfield is String
      @State private var numberOfPeople = 2
      @State private var tipPercentage = 2
    
     let tipPercentages = [10,15,20,25,0]
        
        var total: [Double] {
            let peopleCount = Double(numberOfPeople +  2)
            let tipSelection = Double(tipPercentages[tipPercentage])
            let orderAmount = Double(checkAmount) ?? 0
            // ?? 0 implies orderAmount = 0 incase non-double value is entered in the string
           
            let tipValue = orderAmount / 100 * tipSelection
            let grandTotal = orderAmount + tipValue
            let amountPerPerson = grandTotal/peopleCount
          
            let totalamt = [grandTotal , amountPerPerson ]
            return totalamt
        }
        
        var body: some View {
            NavigationView{
            Form{
                Section{
                    TextField("Amount",text: $checkAmount)
                        .keyboardType(.decimalPad)
                    
                    Picker( "Number of People", selection: $numberOfPeople){
                        ForEach(2 ..< 100 ){
                            Text("\($0) people ")
                        }
                    }
                }
                
                Section(header: Text("How much tip do you want to leave?")) {
                    Picker("Tip Percentage", selection: $tipPercentage){
                        ForEach(0 ..< tipPercentages.count){
                            Text("\(self.tipPercentages[$0])")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Total amount : ") ){
                    Text("$\(total[0] , specifier: "%0.2f")")
                }
                
                Section(header: Text("Amount per person: ")) {
                    Text("$\(total[1], specifier: "%0.2f")")
                }
            } .navigationBarTitle("WeSplit",displayMode: .inline)
                
            }
        }
    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
