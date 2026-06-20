//
//  LoadingView.swift
//  AIDola
//
//  Created by Даниэл Лабецкий on 20.06.2026.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            Text("Welcome to AIDola!")
                .foregroundColor(Color.white)
                .font(Font.largeTitle.bold())
        }
    }
}

#Preview {
    LoadingView()
}
