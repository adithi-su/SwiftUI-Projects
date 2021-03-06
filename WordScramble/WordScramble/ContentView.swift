//
//  ContentView.swift
//  WordScramble
//
//  Created by ADITHI SU on 04/01/21.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]() //String array
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var body: some View {
        NavigationView{
            VStack{
                TextField("Enter your word",text: $newWord, onCommit: addNewWord)
                    .modifier(wordTextfieldStyle())
                List(usedWords, id: \.self){
                    Image(systemName: "\($0.count).circle") //icon
                    Text($0)
                }
            }
            .padding()
            .navigationBarTitle(rootWord)
            .onAppear(perform: startGame)
            .alert(isPresented: $showingError, content: {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            })
        }
    } //end of body
    
    func addNewWord(){ //to be called when user presses enter on the keyboard
        let answer = newWord.lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else{
            return
        }
        
        //extra violation
        guard isOriginal(word: answer) else{
            wordError(title: "Word used already", message: "Be more original!")
            return
        }
        guard isPossible(word: answer) else{
            wordError(title: "Word not recognized", message: "You can't make them up!")
            return
        }
        guard isReal(word: answer) else {
            wordError(title: "Word not possible", message: "That isn't a real world")
            return
        }
        
        usedWords.insert(answer, at: 0) //not appending as then new words would be added at the end, might go off screen
        newWord = ""
    }
    func startGame(){
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try?
                String(contentsOf: startWordsURL){
                let allWords = startWords
                    .components(separatedBy: "\n")
                rootWord = allWords.randomElement()
                    ?? "bookworm"
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)  //check if word hasnt been used already
    }
    
    func isPossible(word: String) -> Bool {
        //to check if word is possible , ex: can't spell car from bookworm
        var tempWord = rootWord.lowercased()
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter){
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        // is the word real, i.e , an actual english word
        let checker = UITextChecker()
        let range = NSRange(location: 0, length:
                                word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String){
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

extension ContentView {
    struct wordTextfieldStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(.title2)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                .padding()
            
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
