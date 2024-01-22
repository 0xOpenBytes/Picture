// PictureSourceImage.swift

import SwiftUI

/**
 `PictureSourceImage` is a view representing an image loaded from a `PictureSource`.
 This view provides a way to display images interactively, adjusting to fit the available space.

*/

public struct PictureSourceImage: View {
    @ObservedObject private var viewModel: InteractableImageViewModel
    /**
    Initializes a `PictureSourceImage` view with a specified picture source.

    - Parameter source: The source of the picture (local or remote).
    */

    public init(
        source: PictureSource
    ) {
        self._viewModel = ObservedObject(
            initialValue: InteractableImageViewModel(source: source)
        )
    }
    /// The body of the `PictureSourceImage` view.

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
