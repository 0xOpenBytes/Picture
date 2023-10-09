import SwiftUI

public struct Picture: View {
    private let sources: [PictureSource]

    @State private var isFullscreen: Bool = false
    @State private var isViewingImage: Bool = false
    @State private var currentSourceIndex: Int = 0

    public init(sources: [PictureSource]) {
        self.sources = sources
    }

    @ViewBuilder
    private var fullscreenView: some View {
        VStack {
            HStack {
                Button(
                    action: {
                        isFullscreen = false
                    },
                    label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 32, height: 32, alignment: .center)
                            .foregroundColor(.gray)
                            .padding(4)
                    }
                )

                Spacer()
            }
            .padding()

            GeometryReader { geometry in
                #if os(macOS)
                TabView(selection: $currentSourceIndex) {
                    ForEach(0 ..< sources.count, id: \.self) { sourceIndex in
                        InteractableImage(source: .cached(sources[sourceIndex]))
                            .frame(
                                maxWidth: geometry.size.width,
                                maxHeight: geometry.size.height
                            )
                            .tag(sourceIndex)
                    }
                }
                .gesture(isViewingImage ? DragGesture() : nil)
                #else
                TabView(selection: $currentSourceIndex) {
                    ForEach(0 ..< sources.count, id: \.self) { sourceIndex in
                        InteractableImage(source: .cached(sources[sourceIndex]))
                            .frame(
                                maxWidth: geometry.size.width,
                                maxHeight: geometry.size.height
                            )
                            .tag(sourceIndex)
                    }
                }
                .tabViewStyle(.page)
                .indexViewStyle(
                    .page(
                        backgroundDisplayMode: .always
                    )
                )
                .gesture(isViewingImage ? DragGesture() : nil)
                #endif
            }
        }
    }

    public var body: some View {
        Group {
            if sources.count == 1 {
                Text("Image")
            } else {
                Text("Images: \(sources.count)")
            }
        }
        .sheet(isPresented: $isFullscreen) {
            fullscreenView
        }
        .onTapGesture {
            isFullscreen = true
        }
    }
}

struct Picture_Preview: PreviewProvider {
    static var previews: some View {
        Picture(image: Image(systemName: "photo.artframe"))
    }
}
