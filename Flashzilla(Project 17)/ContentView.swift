 //
//  ContentView.swift
//  Flashzilla(Project 17)
//
//  Created by mac on 04.09.2023.
//

import SwiftUI
extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset * -10)
    }
}

struct ContentView: View {
    @State private var cards = DataManager.load()

    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true
    @State private var showingEditScreen = false
    var body: some View {
        ZStack{
            Image("background")
                .resizable()
                .ignoresSafeArea()
            
            VStack{
                ZStack{
                    ForEach(Array(cards.enumerated()), id: \.element) { item in
                       
                        CardView(card: item.element) { reinsert in
                            withAnimation{
                                removeCard(at: item.offset, reinsert: reinsert)
                            }
                        }
                            .stacked(at: item.offset, in: cards.count)
                            .allowsTightening(item.offset == cards.count - 1)
                            .accessibilityHidden(item.offset < cards.count - 1)
                    }
                    .allowsHitTesting(timeRemaining > 0)
                    
                    if cards.isEmpty || timeRemaining == 0{
                            Button("Start Again or add new cards", action: resetCards)
                                .padding()
                                .background(.white)
                                .foregroundColor(.black)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
                }
                VStack{
                    Text ("Time: \(timeRemaining)")
                    Text ("Score: \(CardView.score)")
                }
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
           
            }
            VStack{
                HStack{
                    Spacer()
                    
                    Button{
                        showingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }
                Spacer()
            }.foregroundColor(.white)
                .font(.largeTitle)
                .padding()
            
            
            if differentiateWithoutColor || voiceOverEnabled {
                VStack{
                    Spacer()
                    
                    HStack{
                        Button{
                            withAnimation{
                                removeCard(at: cards.count - 1, reinsert: true)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }.accessibilityLabel("wrong")
                         .accessibilityHint("mark your answears as being incorrect")
                        
                        Spacer()
                        Button{
                            withAnimation{
                                removeCard(at: cards.count - 1, reinsert: false)
                            }
                        } label: {
                                Image(systemName: "checkmark.circle")
                                    .padding()
                                    .background(.black.opacity(0.7))
                                    .clipShape(Circle())
                            }
                    }.accessibilityLabel("Correct")
                    .accessibilityHint("mark your answears as being Correct")
                }
            }
        }
        .onReceive(timer){ time in
            guard isActive else {return}
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                if cards.isEmpty == false{
                    isActive = true
                }
            } else {
                isActive = false
            }
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards, content: EditCards.init)
        .onAppear(perform: resetCards)
    }
 
    
    func removeCard(at index: Int, reinsert: Bool) {
        guard index >= 0 else {return}
        if reinsert {
            cards.move(fromOffsets: IndexSet(integer: index), toOffset: 0)
        } else {
            cards.remove(at: index)
        }
        if cards.isEmpty {
            isActive = false
        }
    }
    func resetCards() {
        timeRemaining = 100
        CardView.score = 0
        isActive = true
        cards = DataManager.load()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
