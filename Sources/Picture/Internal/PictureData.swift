import SwiftUI

struct PictureData {
    let source: PictureSource
    var image: Image?

    init(
        source: PictureSource,
        image: Image? = nil
    ) {
        self.source = source
        self.image = image
    }
}
