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
    @StateObject private var cardsController = Cards()
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
                    ForEach(cardsController.cards){ card in
                        CardView(card: card){ isWrong in
                            withAnimation {
                                cardsController.remove(id: card.id)
                                if isWrong {
                                    cardsController.tempAdd(card: card)
                                }
                            }
                        }.stacked(at: cardsController.getIndex(id: card.id) ??  0, in: cardsController.cards.count)
                    }
                }.allowsTightening(timeRemaining > 0)
                if cardsController.cards.isEmpty {
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
                        cardsController.load()
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
            
        }
        .onReceive(timer) { time  in
            guard isActive else { return }
            if cardsController.cards.isEmpty  { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }.onChange(of: scenePhase) { newPhase in
            if newPhase == .active  {
                if cardsController.cards.isEmpty == false  {
                    isActive = true
                }
            } else {
                isActive = false
            }
        }.sheet(isPresented: $isShowingEditScreen, onDismiss: resetCard, content: EditView.init).environmentObject(cardsController)
    }
        
    func resetCard() {
        timeRemaining = 100
        isActive = true
        cardsController.load()
    }
    

    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
