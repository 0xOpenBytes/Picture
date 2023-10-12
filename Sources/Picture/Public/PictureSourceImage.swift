import SwiftUI

public struct PictureSourceImage: View {
    @ObservedObject private var viewModel: InteractableImageViewModel

    public init(
        source: PictureSource
    ) {
        self._viewModel = ObservedObject(
            initialValue: InteractableImageViewModel(source: source)
        )
    }

    public var body: some View {
        if let image = viewModel.image {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            ProgressView()
                .onAppear {
                    viewModel.load()
                }
        }
    }
}

struct PictureSourceImage_Preview: PreviewProvider {
    static var previews: some View {
        PictureSourceImage(source: .local(Image(systemName: "photo.artframe")))
    }
}
