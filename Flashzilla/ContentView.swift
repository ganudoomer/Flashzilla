//
//  ContentView.swift
//  Flashzilla
//
//  Created by Sree on 16/01/22.
//

import SwiftUI

extension View {
    func stacked(at postion: Int,in total: Int) -> some View {
        let offset = Double(total - postion)
        return self.offset(x: 0, y: offset * 10)
    }
}

struct ContentView: View {
    @State private var cards = [Card]()
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled

    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true
    @State private var isShowingEditScreen = false

    
    var body: some View {
        ZStack {
            Image(decorative: "background")
                .resizable()
                .ignoresSafeArea()
            VStack {
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal,20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                
                ZStack {
                    ForEach(0..<cards.count,id:\.self){ index in
                        CardView(card: cards[index]){
                            withAnimation {
                                removeCard(at: index)
                            }
                        }.allowsHitTesting(index == cards.count - 1)
                            .accessibilityHidden(index < cards.count - 1)
                        .stacked(at: index, in: cards.count)
                    }
                }.allowsTightening(timeRemaining > 0)
                if cards.isEmpty {
                    Button("Start Again", action: resetCard)
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button{
                        isShowingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }
                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()
            
            if differentiateWithoutColor || voiceOverEnabled {
                VStack {
                    Spacer()
                    HStack {
                        Button {
                            withAnimation {
                                removeCard(at: cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }.accessibilityLabel("Wrong")
                         .accessibilityHint("Mark your answer as being incorrect.")

                       
                        Spacer()
                        
                        Button {
                            withAnimation {
                                removeCard(at: cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }.accessibilityLabel("Correct")
                         .accessibilityHint("Mark your answer as being correct.")
                        
                    }.foregroundColor(.white)
                     .font(.largeTitle)
                     .padding()
                }
            }
            
            
        }.onReceive(timer) { time  in
            guard isActive else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }.onChange(of: scenePhase) { newPhase in
            if newPhase == .active  {
                if cards.isEmpty == false  {
                    isActive = true
                }
            } else {
                isActive = false
            }
        }.onAppear {
            loadData()
        }.sheet(isPresented: $isShowingEditScreen, onDismiss: resetCard, content: EditView.init)

    }
    
    func removeCard(at index: Int) {
        guard index >= 0 else { return }

        cards.remove(at: index)
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func resetCard() {
        cards = Array(repeating: Card.example, count: 10)
        timeRemaining = 100
        isActive = true
        loadData()
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                cards = decoded
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
