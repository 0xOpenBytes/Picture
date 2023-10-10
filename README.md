# Picture

*🚧 Under Construction 🚧*

Picture is a useful Swift Package Manager project that simplifies the process of displaying multiple images in SwiftUI. It supports both local and remote images and handles the UI, loading, and caching of images. Picture is an excellent tool for enhancing the visual appeal of apps while reducing the time and effort required for image loading and caching.

## Example Usages

```swift
// Single Image or UIImage
var body: some View {
    Picture(image: image)
}

// Single URL
var body: some View {
    Picture(url: imageURL)
}

// Multiple Images or UIImages
var body: some View {
    Picture(images: images)
}

// Multiple URLs
var body: some View {
    Picture(urls: imageURLs)
}

// Multiple URLs or Images
let remoteAndLocalImages: [PictureSource] = [
    .local(image),
    .remote(url)
]

var body: some View {
    Picture(remoteAndLocalImages)
}
```

### Default init

```swift
public init(sources: [PictureSource]) {
    self.sources = sources
}
```
