//
//  ContentView.swift
//  who the balr?
//
//  Created by Caio on 03/07/24.
//

import SwiftUI
import Foundation

extension String {
    var forSorting: String {
        let simple = folding(options: [.diacriticInsensitive, .widthInsensitive, .caseInsensitive], locale: nil)
        return simple.replacingOccurrences(of: "[^\\w\\s]", with: "", options: .regularExpression, range: nil)
    }
}


struct ContentView: View {
    @State private var players = [
        ["anselmo ramon", "anselmo", "aamon"],
        ["cristiano ronaldo", "cr7", "cristiano", "ronaldo"],
        ["dimitri payet", "payet"],
        ["flavio caca rato", "flavio caca-rato", "caca-rato", "caca rato"],
        ["john arias", "arias", "john arias"],
        ["john kennedy", "jk"],
        ["leo jardim"],
        ["lionel messi", "messi", "leo messi"],
        ["lucio maranhao"],
        ["mariano diaz", "mariano"],
        ["moises caicedo", "caicedo"],
        ["neymar junior", "neymar", "neymar jr", "ney"],
        ["nilmar"],
        ["paulo baier", "paulo", "baier"],
        ["raphinha"],
        ["vinicius junior", "vini jr", "vinicius", "vinicius jr", "vini"]
    ]
    @State private var words: [(word: String, correct: Bool)] = []
    @State private var currentPlayer = [""]
    @State private var guess = ""
    @State private var score = 0
    @State private var lives = 5
    @State private var focus = 15.0
    @State private var highScore = 0
    @State private var isAlertShowing = false
    @FocusState private var isFocused: Bool
    var body: some View {
        ZStack {
            Color(.tertiaryLabel).frame(maxWidth: .infinity, maxHeight: .infinity).ignoresSafeArea().onTapGesture {
                isFocused = false
            }
            VStack {
                Text("who the balr?").font(.title.bold()).foregroundStyle(.white)
                ZStack {
                    VStack {
                        List {
                            ForEach(words.indices, id: \.self) { index in
                                Text(words[index].word).foregroundStyle(.white).listRowBackground(words[index].correct ? Color.green : Color.red)
                            }
                        }.listStyle(.plain).background(.white)
                    }.frame(width: 300, height: 320).background(.thickMaterial).clipShape(.rect(cornerRadius: 30))
                    
                    Section {Text("")}.frame(width: 300, height: 320).background(.thinMaterial).opacity(0.6).clipShape(.rect(cornerRadius: 30))
                    
                    Image(currentPlayer[0]).resizable().frame(width: 300, height: 200).opacity(0.5).blur(radius: focus)
                }
                
                Text("pontos = \(score) | vidas = \(lives)").font(.headline.bold()).foregroundStyle(.white)
                
                TextField("", text: $guess).background(.white).padding(.horizontal, 50).padding(.vertical, 20).foregroundStyle(.black).focused($isFocused).textInputAutocapitalization(.never).onSubmit {
                    checkPlayer()
                }
                
                HStack {
                    Button {
                        if guess != "" && guess.count >= 2{
                            withAnimation(.bouncy(duration: 0.7)) {
                                checkPlayer()
                            }
                        }
                    } label: {
                        Text("Enviar").padding().font(.title2.bold()).background(.white).foregroundStyle(.gray).clipShape(.rect(cornerRadius: 20))
                    }
                    
                    Button {
                        focus = 20
                        guess = ""
                        start()
                    } label: {
                        Text("Mudar").padding().font(.title2.bold()).background(.white).foregroundStyle(.gray).clipShape(.rect(cornerRadius: 20))
                    }
                }
                
            }
        }.onAppear() {
            start()
        }.alert("Game over!", isPresented: $isAlertShowing) {
            Button ("Try again") {
                focus = 20
                lives = 5
                score = 0
                guess = ""
                words = []
                start()
            }
        } message: {
            if score > highScore {
                Text("You've got a new high score!\nYou score was \(score) points.")
            } else {
                Text("You score was \(score) points.")
            }
        }
    }
    
    func start() {
        let oldPlayer = currentPlayer
        while currentPlayer == oldPlayer {
            currentPlayer = players.randomElement() ?? ["lionel messi", "messi", "leo messi"]
        }
    }
    
    func checkPlayer() {
        print(guess.lowercased().forSorting)
        if currentPlayer.contains(guess.lowercased().forSorting) {
            words.insert((word: currentPlayer[0].capitalized, correct: true), at: 0)
            score += 1
            lives += 1
            focus = 15
            guess = ""
            start()
        } else {
            words.insert((word: guess, correct: false), at: 0)
            lives -= 1
            
            if focus > 10 {
                focus -= 5
            } else {
                focus -= 3
            }
        
            guess = ""
            if lives == 0 {
                print("Game over!")
                isAlertShowing = true
            }
        }
    }
}


#Preview {
    ContentView()
}
