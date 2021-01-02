//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by ADITHI SU on 02/01/21.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland","Italy","Nigeria","Poland","Russia","Spain","UK","US"] .shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore: Int = 0
    
    var body: some View {
    
        ZStack{
            LinearGradient(gradient:  Gradient(colors: [.blue,.black]), startPoint: .top, endPoint: .bottom)
                      .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack(spacing: 30){
                VStack{
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)  //to add shadow
                    
                    VStack(spacing:25){
                        ForEach(0 ..< 3){
                            number in Button(action: {
                                //flag was tapped
                                self.flagTapped(number)
                                
                            }){
                                Image(self.countries[number])
                                    .renderingMode(.original)
                                    .clipShape(Capsule())
                                    .overlay(Capsule()
                                                .stroke(Color.black,lineWidth:1))
                                    .shadow(color: .black, radius: 2 )
                            }
                        }
                        
                        Text("Current Score : \(userScore)")
                            .foregroundColor(.white)
                            .font(.title)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                    Spacer()
        
                }
            }
        } //end of ZStack
        .alert(isPresented: $showingScore){
            Alert(title: Text(scoreTitle), message: Text("Your score is \(userScore)"), dismissButton: .default(Text("Continue")){
                self.askQuestion()
            })
        }
        

        
    }
    //define functions after body
    func flagTapped(_ number: Int){
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore+=1
        }else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
            userScore-=1
            if userScore < 0{
                userScore = 0
            }
        }
        
        showingScore = true
    }
    
    func askQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
