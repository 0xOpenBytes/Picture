import SwiftUI

// MARK: - Default Implementation

extension Picture
where SingleImageContent == SingleImageView,
      MultipleImageContent == MultipleImageView
{

    public init(
        sources: [PictureSource]
    ) {
        self.init(
            sources: sources,
            singleImageContent: SingleImageView.init,
            multipleImageContent: MultipleImageContent.init
        )
    }

    public init(image: Image) {
        self.init(
            sources: [.local(image)],
            singleImageContent: SingleImageView.init,
            multipleImageContent: MultipleImageContent.init
        )
    }

    public init(url: URL) {
        self.init(
            sources: [.remote(url)],
            singleImageContent: SingleImageView.init,
            multipleImageContent: MultipleImageContent.init
        )
    }

    public init(images: [Image]) {
        self.init(
            sources: images.map(PictureSource.local),
            singleImageContent: SingleImageView.init,
            multipleImageContent: MultipleImageContent.init
        )
    }

    public init(urls: [URL]) {
        self.init(
            sources: urls.map(PictureSource.remote),
            singleImageContent: SingleImageView.init,
            multipleImageContent: MultipleImageContent.init
        )
    }
}

// MARK: - Single Image Initialization

extension Picture where MultipleImageContent == MultipleImageView {
    public init(
        image: Image,
        @ViewBuilder singleImageContent: @escaping (Image) -> SingleImageContent
    ) {
        self.init(
            sources: [.local(image)],
            singleImageContent: singleImageContent,
            multipleImageContent: MultipleImageContent.init
        )
    }

    public init(
        url: URL,
        @ViewBuilder singleImageContent: @escaping (Image) -> SingleImageContent
    ) {
        self.init(
            sources: [.remote(url)],
            singleImageContent: singleImageContent,
            multipleImageContent: MultipleImageContent.init
        )
    }
}

// MARK: - Multiple Image Initialization

extension Picture where SingleImageContent == SingleImageView {
    public init(
        images: [Image],
        @ViewBuilder multipleImageContent: @escaping ([Image]) -> MultipleImageContent
    ) {
        self.init(
            sources: images.map(PictureSource.local),
            singleImageContent: SingleImageView.init,
            multipleImageContent: multipleImageContent
        )
    }

    public init(
        urls: [URL],
        @ViewBuilder multipleImageContent: @escaping ([Image]) -> MultipleImageContent
    ) {
        self.init(
            sources: urls.map(PictureSource.remote),
            singleImageContent: SingleImageView.init,
            multipleImageContent: multipleImageContent
        )
    }
}
