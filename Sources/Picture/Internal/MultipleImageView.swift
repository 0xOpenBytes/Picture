import SwiftUI

// TODO: [P-9](https://github.com/0xOpenBytes/Picture/issues/9)
public struct MultipleImageView: View {
    let images: [Image]

    public var body: some View {
        switch images.count {
        case 0:     placeholderView
        case 1:     SingleImageView(image: images[0])
        case 2:     doubleImageView
        case 3:     tripleImageView
        default:    fallbackImageView

        }
    }

    private var placeholderView: some View {
        Image(systemName: "photo.artframe")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }

    private var doubleImageView: some View {
            VStack {
                images[0]
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                images[1]
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
    }

    private var tripleImageView: some View {
        HStack {
            images[0]
                .resizable()
                .aspectRatio(contentMode: .fit)
            VStack {
                images[1]
                    .resizable()
                    .aspectRatio(contentMode: .fit)

                images[2]
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
    }

    private var fallbackImageView: some View {
        Grid {
            GridRow {
                images[0]
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                images[1]
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            GridRow {
                images[2]
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Image(systemName: "ellipsis")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
}

struct MultipleImageView_Preview: PreviewProvider {
    static var previews: some View {
        MultipleImageView(
            images: [
                Image(systemName: "photo.artframe")
            ]
        )

        MultipleImageView(
            images: [
                Image(systemName: "photo.artframe"),
                Image(systemName: "photo.artframe")
            ]
        )

        MultipleImageView(
            images: [
                Image(systemName: "photo.artframe"),
                Image(systemName: "photo.artframe"),
                Image(systemName: "photo.artframe")
            ]
        )

        MultipleImageView(
            images: [
                Image(systemName: "photo.artframe"),
                Image(systemName: "photo.artframe"),
                Image(systemName: "photo.artframe"),
                Image(systemName: "photo.artframe")
            ]
        )
    }
}
