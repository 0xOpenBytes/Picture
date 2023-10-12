import SwiftUI

// TODO: [P-8](https://github.com/0xOpenBytes/Picture/issues/8)
public struct SingleImageView: View {
    let image: Image

    public var body: some View {
        image
    }
}

struct SingleImageView_Preview: PreviewProvider {
    static var previews: some View {
        SingleImageView(image: Image(systemName: "photo.artframe"))
    }
}
