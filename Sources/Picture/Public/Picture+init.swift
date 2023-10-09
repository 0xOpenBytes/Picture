import SwiftUI

extension Picture {
    public init(image: Image) {
        self.init(sources: [.local(image)])
    }

    public init(url: URL) {
        self.init(sources: [.remote(url)])
    }
    
    public init(images: [Image]) {
        self.init(sources: images.map(PictureSource.local))
    }

    public init(urls: [URL]) {
        self.init(sources: urls.map(PictureSource.remote))
    }
}
