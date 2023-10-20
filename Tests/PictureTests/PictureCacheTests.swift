import XCTest
import SwiftUI
@testable import Picture

final class PictureCacheTests: XCTestCase {
  private let faviconURL: URL = .init(string: "https://openbytes.com/favicon.png")!

  internal func testNotFoundImageForSpecifiedURL() {
    let cache = PictureCache()

    let image = cache.get(url: faviconURL)

    XCTAssertNil(image)
  }

  internal func testFoundImageForSpecifiedURL() {
    let cache = PictureCache()

    let expectedImage = Image("house")

    cache.set(value: expectedImage, for: faviconURL)

    let actualImage = cache.get(url: faviconURL)

    XCTAssertEqual(actualImage, expectedImage)
  }
}
