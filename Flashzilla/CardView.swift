//
//  CardView.swift
//  Flashzilla
//
//  Created by Sree on 16/01/22.
//

import SwiftUI


extension RoundedRectangle {
    func fillWithOffset(offset: CGSize) -> some View {
        var backgroundColor = Color.white
        if offset.width > 0 {
            backgroundColor = .green
        } else if offset.width < 0 {
            backgroundColor = .red
        } else {
            backgroundColor = .white
        }
        return self.fill(backgroundColor)
    }
}


struct CardView: View {
    let card: Card
    var removal: ((_ isWrong: Bool) -> Void)? = nil

    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    
    
    @State private var feedback = UINotificationFeedbackGenerator()
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25,style: .continuous)
                .fill(
                    differentiateWithoutColor ?
                        .white : .white
                        .opacity(1 - Double(abs(offset.width / 50)))
                )
                .background(
                    differentiateWithoutColor ? nil :
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fillWithOffset(offset:offset)
                )
                .shadow(radius: 20)
            VStack {
                if voiceOverEnabled {
                    Text(isShowingAnswer ? card.answer : card.prompt)
                                .font(.largeTitle)
                                .foregroundColor(.black)
                } else {
                        Text(card.prompt)
                            .font(.title)
                            .foregroundColor(.black)
                        
                        if isShowingAnswer {
                            Text(card.answer)
                                .font(.title)
                                .foregroundColor(.gray)
                        }
                }
                
              
             
            }.padding(20)
                .multilineTextAlignment(.center).onTapGesture {
                    isShowingAnswer.toggle()
                }
            
        }.frame(width: 450, height: 250)
            .rotationEffect(.degrees(Double(offset.width / 5)))
            .offset(x: offset.width * 5, y:0)
            .accessibilityAddTraits(.isButton)
            .opacity((2 - Double(abs(offset.width / 50))))
            .gesture(
                DragGesture().onChanged { gesture in
                    offset = gesture.translation
                    feedback.prepare()
                }.onEnded { _ in
                    if abs(offset.width) > 100 {
                        if offset.width > 0 {
                            removal?(false)
                            feedback.notificationOccurred(.success)
                        } else {
                            feedback.notificationOccurred(.error)
                            removal?(true)
                        }
                       
                    } else {
                        withAnimation {
                            offset = .zero

                        }
                                            }
                }
            ).animation(.spring(), value: offset)

           
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card())
    }
}
