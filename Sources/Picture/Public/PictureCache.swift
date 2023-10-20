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
