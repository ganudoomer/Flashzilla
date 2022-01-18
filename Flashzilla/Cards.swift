//
//  CardsController.swift
//  Flashzilla
//
//  Created by Sree on 17/01/22.
//

import SwiftUI

// TODO: Hide the Card instead of deleting it. Also need to Bring the Card to the end
// Which should be cool to do
// But got an idea of what to do


class Card: Codable, Identifiable {
    var  id = UUID()
    var prompt = ""
    var answer = ""
    var isRemoved = false
}

@MainActor class Cards: ObservableObject {
    @Published  var cards = [Card]()
    
    let savePath = FileManager.doucmentsDir.appendingPathComponent("cardsV1")
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            let decoded = try JSONDecoder().decode([Card].self, from: data)
            self.cards = decoded
        } catch {
            print("Some Random Error \(error.localizedDescription)")
            self.cards = []
        }
    }
    
    
    private func save() {
        do {
            let data = try JSONEncoder().encode(cards)
            try data.write(to: savePath,options: [.atomic,.completeFileProtection])
        } catch {
            print("Error occurred While Saving")
        }
    }
    
    
    func add(card: Card) {
        cards.append(card)
        save()
    }
    
    func tempAdd(card: Card) {
        objectWillChange.send()
        let newCard = Card()
        newCard.answer = card.answer
        newCard.prompt = card.prompt
        cards.insert(newCard, at: 0)
    }
    
    func remove (id: UUID){
        if let index =  cards.firstIndex(where: { item in
            return item.id == id
        }) {
         cards.remove(at: index)
     }
    }
    
    func removeFromIndex(index: IndexSet){
        cards.remove(atOffsets: index)
        save()
    }
    
    func hideCard (id: UUID){
        objectWillChange.send()
        if let index = cards.firstIndex(where: { item in
            return item.id == id
        }) {
            cards[index].isRemoved = true
        }
    }
    
    func getIndex(id: UUID) -> Int?{
        let index = cards.firstIndex(where: { item in
            return item.id == id
        })
        return index
    }
    
    func load(){
        do {
            let data = try Data(contentsOf: savePath)
            let decoded = try JSONDecoder().decode([Card].self, from: data)
            self.cards = decoded
        } catch {
            print("Some Random Error \(error.localizedDescription)")
            self.cards = []
        }
    }
}
