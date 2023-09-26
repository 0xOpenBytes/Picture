import SwiftUI

public struct Picture: View {
    public var body: some View {
        Image(systemName: "photo.artframe")
    }
}

private struct Picture_Preview: PreviewProvider {
    static var previews: some View {
        Picture()
    }
}
