import SwiftUI

public struct InteractableImage: View {
    @ObservedObject private var viewModel: InteractableImageViewModel

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

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                viewModel.onDragGestureChanged(value: value.translation)
            }
            .onEnded { value in
                viewModel.onDragGestureEnded()
            }
    }

    public init(source: PictureSource) {
        self._viewModel = ObservedObject(
            initialValue: InteractableImageViewModel(source: source)
        )
    }

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
