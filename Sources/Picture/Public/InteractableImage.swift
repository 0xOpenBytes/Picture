
// InteractableImage.swift

import SwiftUI

/**
The `InteractableImage` view allows users to interact with an image. It supports the following features:

- Pinch gestures to zoom in and out on the image
- Drag gestures to pan the image
- A reset button that restores the image to its original size and position
- Accessibility actions to allow VoiceOver users to zoom in and out

 - Note: The view manages its state, including zoom level and offset, using the `InteractableImageViewModel` object.
  Access this object through the `viewModel` property.
*/

public struct InteractableImage: View {
    @ObservedObject private var viewModel: InteractableImageViewModel

    /**
     Gesture for magnifying the image.
     - Parameters:
       - value: The magnification value.
    */
    private var magnificationGesture: some Gesture {
        MagnifyGesture()
            .onChanged { value in
                viewModel.onMagnificationGestureChanged(
                    value: value.magnification - 1
                )
            }
            .onEnded { value in
                viewModel.onMagnificationGestureEnded()
            }
    }

    /**
     Gesture for dragging and repositioning the image.
     - Parameters:
       - value: The translation value.
    */
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                viewModel.onDragGestureChanged(value: value.translation)
            }
            .onEnded { value in
                viewModel.onDragGestureEnded()
            }
    }

    /**
     Initializes the 'InteractableImage' view with a specified picture source.
     - Parameters:
       - source: The source of the picture (local file or remote URL).
    */
    public init(source: PictureSource) {
        self._viewModel = ObservedObject(
            initialValue: InteractableImageViewModel(source: source)
        )
    }

    /**
     Body of the 'InteractableImage' view, handling image display, zoom, and gestures.
     - Returns: A SwiftUI `View` representing the interactive image.
    */
    public var body: some View {
        if let image = viewModel.image {
            ZStack {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(viewModel.zoom)
                    .offset(viewModel.offset)
                    .gesture(
                        SimultaneousGesture(
                            magnificationGesture,
                            dragGesture
                        )
                    )
                    .accessibilityZoomAction { action in
                        if action.direction == .zoomIn {
                            viewModel.totalZoom += 1
                        } else {
                            viewModel.totalZoom -= 1
                        }
                    }

                if viewModel.isZoomed || viewModel.isOffset {
                    VStack {
                        Spacer()

                        HStack {
                            Text("Zoom: x\(String(format: "%0.2f", viewModel.zoom))")
                            Spacer()
                            Text("Position: \(String(format: "%0.0f", viewModel.offset.width)), \(String(format: "%0.0f", viewModel.offset.height))")
                            Spacer()
                            Button(
                                action: {
                                    viewModel.reset()
                                },
                                label: {
                                    Image(systemName: "arrow.uturn.backward.circle.fill")
                                        .resizable()
                                        .frame(width: 32, height: 32, alignment: .center)
                                        .padding(4)
                                        .accessibilityLabel("Reset")
                                }
                            )
                        }
                        .padding()
                        .background()
                        .padding(.bottom, 40)
                    }
                }
            }
            .onDisappear(perform: viewModel.reset)
        } else {
            ProgressView()
                .onAppear {
                    viewModel.load()
                }
        }
    }
}

struct InteractableImage_Preview: PreviewProvider {
    static var previews: some View {
        InteractableImage(source: .local(Image(systemName: "photo.artframe")))
    }
}
