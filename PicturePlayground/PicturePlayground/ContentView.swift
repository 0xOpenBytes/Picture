//
//  ContentView.swift
//  PicturePlayground
//
//  Created by Ahmed Shendy on 09/10/2023.
//

import SwiftUI
import Picture

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, Picture!")
            Picture(
                images: [.init("p1"), .init("p2"), .init("p3"), .init("p4"), .init("p5")]
            )
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
