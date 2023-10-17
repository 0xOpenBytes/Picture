import SwiftUI

public struct Picture<
    SingleImageContent: View,
    MultipleImageContent: View
>: View {
    private let sources: [PictureSource]
    private let singleImageContent: (Image) -> SingleImageContent
    private let multipleImageContent: ([Image]) -> MultipleImageContent


    @ObservedObject private var viewModel: PictureViewModel
    @State private var isFullscreen: Bool = false
    @State private var isViewingImage: Bool = false
    @State private var currentSourceIndex: Int = 0

    public init(
        sources: [PictureSource],
        @ViewBuilder singleImageContent: @escaping (Image) -> SingleImageContent,
        @ViewBuilder multipleImageContent: @escaping ([Image]) -> MultipleImageContent
    ) {
        self._viewModel = ObservedObject(initialValue: PictureViewModel(sources: sources))
        self.sources = sources
        self.singleImageContent = singleImageContent
        self.multipleImageContent = multipleImageContent
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
            switch viewModel.images.count {
            case 0:
                ProgressView()
                    .onAppear {
                        viewModel.load()
                    }
            case 1:     singleImageBody
            default:    multipleImageBody
            }
        }
        .sheet(isPresented: $isFullscreen) {
            fullscreenView
        }
        .onTapGesture {
            isFullscreen = true
        }
    }

    @ViewBuilder
    private var singleImageBody: some View {
        if let image = viewModel.images.first {
            singleImageContent(image)
        }
    }

    @ViewBuilder
    private var multipleImageBody: some View {
        multipleImageContent(viewModel.images)
    }
}

struct Picture_Preview: PreviewProvider {
    static var previews: some View {
        Picture(image: Image(systemName: "photo.artframe"))
    }
}
