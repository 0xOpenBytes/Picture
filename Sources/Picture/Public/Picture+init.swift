// Picture+init.swift

import SwiftUI

// MARK: - Default Implementation

extension Picture
where SingleImageContent == SingleImageView,
      MultipleImageContent == MultipleImageView
{
    /**
    Creates a picture view with the default single and multiple image views.

    This initializer uses the `SingleImageView` and `MultipleImageView` types to display the images in the picture view. 
    These types are defined in the same file as the `Picture` type and provide a simple and consistent appearance for the images.
     
     - Parameters:
       - sources: An array of 'PictureSource' instances representing the sources of the images (local or remote).
     */

    public init(
        sources: [PictureSource]
    ) {
        self.init(
            sources: sources,
            singleImageContent: SingleImageView.init,
            multipleImageContent: MultipleImageContent.init
        )
    }
    /**
     Initializes a 'Picture' view with a single image, using default content views for single and multiple images.
     
     - Parameters:
       - image: The image to be displayed.
     */

    public init(image: Image) {
        self.init(
            sources: [.local(image)],
            singleImageContent: SingleImageView.init,
            multipleImageContent: MultipleImageContent.init
        )
    }
    /**
     Initializes a 'Picture' view with an image from a URL.
     
     - Parameters:
       - url: The URL of the remote image.
     */

    public init(url: URL) {
        self.init(
            sources: [.remote(url)],
            singleImageContent: SingleImageView.init,
            multipleImageContent: MultipleImageContent.init
        )
    }
    /**
     Initializes a 'Picture' view with an array of images.
     
     - Parameters:
       - images: An array of 'Image' instances to be displayed.
     */

    public init(images: [Image]) {
        self.init(
            sources: images.map(PictureSource.local),
            singleImageContent: SingleImageView.init,
            multipleImageContent: MultipleImageContent.init
        )
    }
    /**
     Initializes a 'Picture' view with an array of URLs representing remote images.
     
     - Parameters:
       - urls: An array of 'URL' instances pointing to remote images.
     */

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
     /**
     Creates a picture view with a single image and a custom single image view.
     
     - Parameters:
       - image: The image to be displayed.
       - singleImageContent: A view builder closure for customizing the display of a single image.
     */

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
    /**
     Initializes a 'Picture' view with an image from a URL and custom content view for single images.
     
     - Parameters:
       - url: The URL of the remote image.
       - singleImageContent: A view builder closure for customizing the display of a single image.
     */

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
     /**
     Initializes a 'Picture' view with an array of images and custom content view for multiple images.
     
     - Parameters:
       - images: An array of 'Image' instances to be displayed.
       - multipleImageContent: A view builder closure for customizing the display of multiple images.
     */

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
    /**
     Initializes a 'Picture' view with an array of URLs representing remote images and custom content view for multiple images.
     
     - Parameters:
       - urls: An array of 'URL' instances pointing to remote images.
       - multipleImageContent: A view builder closure for customizing the display of multiple images.
     */
     
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
