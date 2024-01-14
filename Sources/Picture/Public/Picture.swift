
// Picture.swift

import SwiftUI

/**
The `Picture` custom view is designed to display one or more images from various sources. 
To instantiate this view, you can provide an array of `PictureSource` values, representing image sources such as local files or remote URLs.
Inside the view, a `PictureViewModel` object manages the logic and data for loading and displaying the images.

The `Picture` view supports the following features:

- Fullscreen mode for viewing images in a larger size and swiping between them.
- Support for zoom and drag gestures when interacting with images in fullscreen mode.
- A close button to exit fullscreen mode and return to the original view.
- Accessibility actions allowing VoiceOver users to zoom in and out on the images.

- Parameters:
    - sources: An array of `PictureSource` representing the sources of the images.
    - singleImageContent: A closure that takes a single `Image` as an argument and returns the content for a single image.
    - multipleImageContent: A closure that takes an array of `Image` as an argument and returns the content for multiple images.
*/
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

    /**
    Initializes the `Picture` view with specified picture sources and content closures.

    - Parameters:
        - sources: An array of `PictureSource` representing the sources of the images.
        - singleImageContent: A closure that takes a single `Image` as an argument and returns the content for a single image.
        - multipleImageContent: A closure that takes an array of `Image` as an argument and returns the content for multiple images.
    */
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

    /**
     The body of the 'Picture' view, presenting either a single image or a gallery of multiple images.
     - Returns: A SwiftUI `View` representing the picture.
    */
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

    /**
     The body of the 'Picture' view when displaying a single image.
     - Returns: A SwiftUI `View` representing the single image.
    */
    @ViewBuilder
    private var singleImageBody: some View {
        if let image = viewModel.images.first {
            singleImageContent(image)
        }
    }

    /**
     The body of the 'Picture' view when displaying multiple images.
     - Returns: A SwiftUI `View` representing the multiple images.
     */
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
