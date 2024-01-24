
// PictureCache.swift

import SwiftUI

/**
 `PictureSource` represents the source of an image, which can be either local or remote. It also provides functionality for caching and loading images.

Note: Loading a remote image is an asynchronous operation. Use async/await when calling the load method.
*/

public enum PictureSource {
    public private(set) static var cache: PictureCache = PictureCache()

    case local(Image)
    case remote(URL)
    /**
    Returns a cached local copy if available for a remote image; otherwise, returns the original source.

    - Parameter: The original `PictureSource` instance.
    - Returns: A `PictureSource` instance, with a local copy instead of a remote URL.
    */

    public static func cached(_ source: PictureSource) -> PictureSource {
        guard
            case let .remote(url) = source,
            let cachedImage = cache.get(url: url)
        else { return source }

        return .local(cachedImage)
    }
    /**
    This method uses the `async/await` syntax to load the image from the picture source asynchronously.
    If the source is a local image, it simply returns the associated image. 
    If the source is a remote URL, it uses the `URLSession` to convert it to an `Image` value. 
    It also caches the image for future use.

    - Returns: An `Image` representing the loaded image, or `nil` if loading fails.
    - Throws: An error if loading encounters an issue.
    */

    public func load() async throws -> Image? {
        switch self {
        case .local(let image):
            return image
        case .remote(let url):
            let (data, _) = try await URLSession.shared.data(from: url)

            let image: Image

            #if os(macOS)
            guard let loadedImage = NSImage(data: data) else {
                return nil
            }

            image = Image(nsImage: loadedImage)
            #else
            guard let loadedImage = UIImage(data: data) else {
                return nil
            }

            image = Image(uiImage: loadedImage)
            #endif


            Self.cache.set(value: image, for: url)

            return image
        }
    }
}
