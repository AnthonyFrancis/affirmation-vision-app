//
//  SplashScreenView.swift
//  visionboard
//
//  Created by Anthony Francis on 18/12/2024.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var opacity = 0.5
    @State private var scale = 0.8
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                Text("Vision Board Pro 👁️")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                    .opacity(opacity)
                    .scaleEffect(scale)
            }
            .onAppear {
                withAnimation(.easeIn(duration: 1.0)) {
                    opacity = 1.0
                    scale = 1.0
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}
