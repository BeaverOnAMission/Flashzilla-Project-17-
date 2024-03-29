//
//  CardView.swift
//  Flashzilla(Project 17)
//
//  Created by mac on 16.09.2023.
//

import SwiftUI
extension Shape {
    func fill(using offset: CGSize) -> some View {
        if offset.width == 0 {
            return self.fill(.white)
        } else if offset.width < 0 {
            return self.fill(.red)
        } else {
            return self.fill(.green)
        }
    }
}

struct CardView: View {
    let card: Card
    var removal: ((Bool) -> Void)? = nil
    
    @State private var feedback = UINotificationFeedbackGenerator()
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    @State private var isShowingAnswer = false
    static var score = 0
    @State private var offset = CGSize.zero
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(
                    differentiateWithoutColor
                    ? .white
                    : .white
                        .opacity(1-Double(abs(offset.width/50))))
                .background(
                    differentiateWithoutColor
                    ? nil
                    : RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(using: offset)
                    )
                .shadow(radius: 10)
             
            VStack {
                if voiceOverEnabled{
                    Text(isShowingAnswer ? card.answer : card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                }
                else {
                    Text(card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                    
                    if isShowingAnswer {
                        Text(card.answer)
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                }
            }
             .padding()
             .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(Double(offset.width/5)))
        .offset(x: offset.width * 5, y:0)
        .opacity(1.75-Double(abs(offset.width/50)))
        .accessibilityAddTraits(.isButton)
        .gesture(
            DragGesture()
                .onChanged{ gesture in
                    offset = gesture.translation
                    feedback.prepare()
                }
                .onEnded{ _ in
                    if offset.width < 0 {
                        feedback.notificationOccurred(.error)
                    }
                    if offset.width > 100 {
                        CardView.score += 1
                        removal?(false)
                    }
                    else if offset.width < 100{
                        CardView.score -= 1
                      removal?(true)
                        offset = .zero
                    }
                        else {
                        offset = .zero
                    }
                }
        )
        .onTapGesture {
            isShowingAnswer.toggle()
        }
        .animation(.spring(), value: offset)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.example)
    }
}
