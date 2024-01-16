
// PictureCache.swift

import SwiftUI

/**
 `PictureCache` is a class designed for caching images based on their URLs.
  This class helps reduce the load on network resources by storing previously fetched images in memory.

- Note
    - Use this cache for storing and retrieving images associated with their respective URLs.
    - The cache implements a thread-safe approach using an internal lock (`NSLock`) to handle concurrent access.

- Warning: Avoid overusing memory by managing the cache size and considering cleanup strategies.

*/

public class PictureCache {
    private var cache: [URL: Image]
    private var lock: NSLock

    /**
    Initializes a new instance of `PictureCache`.

    The cache is initially empty, and the lock is set up for thread safety.
    */

    public init() {
        cache = [:]
        lock = NSLock()
    }
    /**
    Retrieves an image from the cache based on its URL.

    - Parameters:
        - url: The URL associated with the image.

    - Returns: The cached `Image` if available; otherwise, `nil`.  
    */

    public func `get`(url: URL) -> Image? {
        lock.lock(); defer { lock.unlock() }

        return cache[url]
    }
    /**
    Sets or updates the cache with an image for a specific URL.

    - Parameters:
    - value: The `Image` to be cached.
    - url: The URL associated with the image.
    */

    public func `set`(value: Image?, for url: URL) {
        lock.lock(); defer { lock.unlock() }

        cache[url] = value
    }
}
