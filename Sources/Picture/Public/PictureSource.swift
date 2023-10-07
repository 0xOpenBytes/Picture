import SwiftUI

public class PictureCache {
    private var cache: [URL: Image]
    private var lock: NSLock

    public init() {
        cache = [:]
        lock = NSLock()
    }

    public func `get`(url: URL) -> Image? {
        lock.lock(); defer { lock.unlock() }

        return cache[url]
    }

    public func `set`(value: Image?, for url: URL) {
        lock.lock(); defer { lock.unlock() }

        cache[url] = value
    }
}

public enum PictureSource {
    public private(set) static var cache: PictureCache = PictureCache()

    case local(Image)
    case remote(URL)

    public static func cached(_ source: PictureSource) -> PictureSource {
        guard
            case let .remote(url) = source,
            let cachedImage = cache.get(url: url)
        else { return source }

        return .local(cachedImage)
    }

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
