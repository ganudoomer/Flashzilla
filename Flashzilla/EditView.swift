//
//  EditView.swift
//  Flashzilla
//
//  Created by Sree on 16/01/22.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    @State private var newPrompt = ""
    @State private var newAnswer = ""
    @EnvironmentObject var cardsController: Cards
    
    
    var body: some View {
        NavigationView {
            List {
                Section("Add a new card") {
                    TextField("Prompt",text: $newPrompt)
                    TextField("Answer",text: $newAnswer)
                    Button("Add new card"){
                        add()
                    }
                    Section {
                        ForEach(cardsController.cards) { card in
                            VStack(alignment: .leading){
                                Text(card.prompt).font(.headline)
                                Text(card.answer).foregroundColor(.secondary)
                            }
                        }.onDelete { index in
                            cardsController.removeFromIndex(index: index)
                        }
                    }
                }
            }
            .navigationTitle("Edit Cards")
                       .toolbar {
                           Button("Done", action: done)
                       }
                       .listStyle(.grouped)
        
        }
    }
    func done() {
        dismiss()
    }
    

    @MainActor func add(){
        let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        
        guard trimmedAnswer.isEmpty == false && trimmedPrompt.isEmpty == false else { return }
        let card = Card()
        card.prompt = trimmedPrompt
        card.answer = trimmedAnswer
        cardsController.add(card: card)
        newPrompt = ""
        newAnswer = ""
        
    }
        
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView().environmentObject(Cards())
    }
}
