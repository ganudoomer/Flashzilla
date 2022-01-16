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
    @State private var cards = [Card]()
    
    
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
                        ForEach(0..<cards.count, id: \.self) { index in
                            VStack(alignment: .leading){
                                Text(cards[index].prompt).font(.headline)
                                Text(cards[index].answer).foregroundColor(.secondary)
                            }
                        }.onDelete(perform: delete)
                    }
                }
            }
            .navigationTitle("Edit Cards")
                       .toolbar {
                           Button("Done", action: done)
                       }
                       .listStyle(.grouped)
            .onAppear(perform: loadData)
        
        }
    }
    func done() {
        dismiss()
    }
    
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                cards = decoded
            }
        }
    }
    
    func add(){
        let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        
        guard trimmedAnswer.isEmpty == false && trimmedPrompt.isEmpty == false else { return }
        let card = Card(prompt: trimmedPrompt, answer: trimmedAnswer)
        cards.insert(card, at: 0)
        save()
        
        
    }
    
    func save(){
        if let data = try? JSONEncoder().encode(cards) {
            UserDefaults.standard.set(data, forKey: "Cards")
        }
    }
    
    func delete(at offset: IndexSet){
        cards.remove(atOffsets: offset)
        save()
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
