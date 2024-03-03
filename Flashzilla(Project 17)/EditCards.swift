//
//  EditCards.swift
//  Flashzilla(Project 17)
//
//  Created by mac on 18.10.2023.
//

import SwiftUI

struct EditCards: View {
    @Environment((\.dismiss)) var dismiss
    @State private var cards = DataManager.load()
    @State private var newPrompt = ""
    @State private var newAnswear = ""
    
    var body: some View {
        NavigationView{
            List{
                Section("add new card") {
                        TextField("prompt", text:$newPrompt)
                        TextField("answear", text: $newAnswear)
                        Button("Add card", action: addCard)
                    
                }
                Section{
                    ForEach(0..<cards.count, id: \.self) {index in
                        VStack(alignment: .leading){
                            Text(cards[index].prompt)
                                .font(.headline)
                            Text(cards[index].answer)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete(perform: removeCards)
                }
            }.navigationTitle("Edit Cards")
            .toolbar{
                Button("Done", action: done)
            }
            .listStyle(.grouped)
        }
    }
    func done(){
        dismiss()
    }
    

    func addCard() {
        let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswear = newAnswear.trimmingCharacters(in: .whitespaces)
        guard trimmedPrompt.isEmpty == false && trimmedAnswear.isEmpty == false else { return }
        let card = Card(prompt: trimmedPrompt, answer: trimmedAnswear)
        cards.insert(card, at: 0)
        DataManager.save(cards)
        newPrompt = ""
        newAnswear = ""
        
    }
    func removeCards(at offsets: IndexSet) {
        cards.remove(atOffsets: offsets)
        DataManager.save(cards)
    }
}

struct EditCards_Previews: PreviewProvider {
    static var previews: some View {
        EditCards()
    }
}
