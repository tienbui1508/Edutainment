//
//  ContentView.swift
//  Edutainment
//
//  Created by Tien Bui on 29/5/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var difficulty = 2
    @State private var numberOfQuestions = 5
    @State private var questionCount = 0
    @State private var answer = 0
    @State private var correctAnswer = 0
    @State private var score = 0
    @State private var alertTitle = ""
    @State private var message = ""
    @State private var question = ""
    @State private var askedNumbers1 = [Int]()
    @State private var askedNumbers2 = [Int]()
    @FocusState private var inputIsFocused: Bool
    @State private var showingResult = false
    @State private var showingFinalResult = false
    
    var questionOptions: [Int] {
        if difficulty == 2 {
            return [5, 10]
        } else {
            return [5, 10, 15]
        }
    }
    
    
    var body: some View {
        VStack {
            
            Stepper("Multiplication tables up to __\(difficulty)__", value: $difficulty, in: 2...12, step: 1)
            
            
            VStack(alignment: .leading) {
                Text("Number of questions")
                Picker("Number of questions", selection: $numberOfQuestions) {
                    ForEach(questionOptions, id: \.self) {
                        Text(String($0))
                    }
                }.pickerStyle(.segmented)
            }
            
            Button {
                if questionCount == 0 {
                    newQuestion()
                } else {
                    checkAnswer()
                    showingResult = true
                    if questionCount == numberOfQuestions {
                        showingFinalResult = true
                    }
                }
            } label: {
                ZStack {
                    Rectangle()
                        .clipShape(Capsule())
                        .frame(height: 40)
                    Text(questionCount == 0 ? "Play" : "Check")
                        .foregroundColor(.white)
                        .bold()
                }
            }
            
            
            Text(question)
            TextField("Answer:", value: $answer, format: .number)
                .keyboardType(.numberPad)
                .focused($inputIsFocused)
                .onSubmit {
                    answer = 0
                }
            
                .alert(alertTitle, isPresented: $showingResult) {
                    Button("Next question") {
                        if questionCount != numberOfQuestions {
                            newQuestion()
                        } 
                    }
                } message: {
                    Text(message)
                }
            
                .alert("Game over!", isPresented: $showingFinalResult) {
                    Button("New game", action: reset)
                } message: {
                    Text("Your final score is \(score)")
                }
            
            
            Spacer()
            Text("Score: \(score)")
            Text("question count: \(questionCount)")
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    inputIsFocused = false
                }
            }
        }
        .padding()
    }
    
    
    func checkAnswer() {
        if answer == correctAnswer {
            score += 1
            alertTitle = "Correct!"
            message = "Good job!"
        } else {
            alertTitle = "Wrong!"
            message = "The correct answer is \(correctAnswer)"
        }
    }
    
    func newQuestion() {
        
        answer = 0
        
        questionCount += 1
        
        
        var number1 = Int.random(in: 2...12)
        var number2 = Int.random(in: 2...difficulty)
        while askedNumbers1.contains(number1) && askedNumbers2.contains(number2) {
            number1 = Int.random(in: 2...12)
            number2 = Int.random(in: 2...difficulty)
        }
        correctAnswer = number1 * number2
        question = "Q\(questionCount). What is \(number1) x \(number2)?"
        askedNumbers1.append(number1)
        askedNumbers2.append(number2)
    }
    
    func reset() {
        questionCount = 0
        askedNumbers1.removeAll()
        askedNumbers2.removeAll()
        question = ""
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
