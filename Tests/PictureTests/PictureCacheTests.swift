import XCTest
import SwiftUI
@testable import Picture

internal final class PictureCacheTests: XCTestCase {
  private let faviconURL: URL = .init(string: "https://openbytes.com/favicon.png")!

  internal func testNotFoundImageForSpecifiedURL() {
    let cache = PictureCache()

    let image = cache.get(url: faviconURL)

    XCTAssertNil(image)
  }

  internal func testFoundImageForSpecifiedURL() {
    let sut = PictureCache()

    let expectedImage = Image("house")

    sut.set(value: expectedImage, for: faviconURL)

    let actualImage = sut.get(url: faviconURL)

    XCTAssertEqual(actualImage, expectedImage)
  }
}
