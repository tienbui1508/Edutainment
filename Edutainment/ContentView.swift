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
    @State private var answer: Int? = nil
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

    let iconList = ["bear", "buffalo", "chick", "chicken", "cow", "crocodile", "dog", "duck", "elephant", "frog", "giraffe", "goat", "gorilla", "hippo", "horse", "monkey", "moose", "narwhal", "owl", "panda", "parrot", "penguin", "pig", "rabbit", "rhino", "sloth", "snake", "walrus", "whale", "zebra"]

    var questionOptions: [Int] {
        if difficulty == 2 {
            return [5, 10]
        } else {
            return [5, 10, 15]
        }
    }

    var body: some View {
        VStack {
            if questionCount == 0 {
                Stepper("Multiplication tables up to __\(difficulty)__", value: $difficulty, in: 2...12, step: 1)
                VStack(alignment: .leading) {
                    Text("Number of questions")
                    Picker("Number of questions", selection: $numberOfQuestions) {
                        ForEach(questionOptions, id: \.self) {
                            Text(String($0))
                        }
                    }.pickerStyle(.segmented)
                }
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
                    Image(iconList.randomElement() ?? "bear")

                    Text(questionCount == 0 ? "Play" : "Submit")
                        .background(.thinMaterial)
                        .opacity(0.8)
                        .foregroundColor(.secondary)
                        .font(.title)
                        .bold()
                        .animation(.default, value: questionCount)
                }
            }

            if questionCount > 0 {
                VStack(alignment: .center) {
                    Text("Question number \(questionCount)")
                        .font(.headline)
                    Text("")
                    Text(question)
                        .font(.title)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .animation(.default, value: questionCount)
                
                Text("Answer")
                TextField("Type your answer here", value: $answer, format: .number)
                    .keyboardType(.numberPad)
                    .focused($inputIsFocused)
                    .onSubmit {
                        checkAnswer()
                        showingResult = true
                        if questionCount == numberOfQuestions {
                            showingFinalResult = true
                        }
                    }
                    .onAppear {
                        UITextField.appearance().clearButtonMode = .whileEditing
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
                        Text("Your final score is \(score)/\(numberOfQuestions)")
                    }

                Spacer()
                Text("Score: \(score)")
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                
                Button {
                    inputIsFocused = false
                } label: {
                    Image(systemName: "keyboard.chevron.compact.down")
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
        answer = nil

        questionCount += 1

        var number1 = Int.random(in: 2...12)
        var number2 = Int.random(in: 2...difficulty)
        while askedNumbers1.contains(number1) && askedNumbers2.contains(number2) {
            number1 = Int.random(in: 2...12)
            number2 = Int.random(in: 2...difficulty)
        }
        correctAnswer = number1 * number2
        question = "What is \(number1) x \(number2)?"
        askedNumbers1.append(number1)
        askedNumbers2.append(number2)
    }

    func reset() {
        questionCount = 0
        askedNumbers1.removeAll()
        askedNumbers2.removeAll()
        question = ""
        answer = nil
        score = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
