import OSLog
import SwiftUI

class InteractableImageViewModel: ObservableObject {
    private enum Constants {
        static let defaultScale: CGFloat = 1.0
        static let defaultOffset: CGSize = .zero
    }

    private let logger = Logger(subsystem: "Picture", category: "UI")
    private var task: Task<Void, Never>?

    let source: PictureSource

    @Published var image: Image?
    @Published var isLoading: Bool
    @Published var loadingError: Error?
    @Published var currentZoom: CGFloat
    @Published var totalZoom: CGFloat
    @Published var currentOffset: CGSize
    @Published var totalOffset: CGSize


    var zoom: CGFloat {
        currentZoom + totalZoom
    }

    var offset: CGSize {
        CGSize(
            width: currentOffset.width + totalOffset.width,
            height: currentOffset.height + totalOffset.height
        )
    }

    var isZoomed: Bool {
        zoom != Constants.defaultScale
    }

    var isOffset: Bool {
        offset != Constants.defaultOffset
    }

    init(source: PictureSource) {
        self.source = source
        self.task = nil
        self.image = nil
        self.isLoading = false
        self.loadingError = nil
        self.currentZoom = 0.0
        self.totalZoom = Constants.defaultScale
        self.currentOffset = .zero
        self.totalOffset = Constants.defaultOffset
    }

    deinit {
        task?.cancel()
    }

    @MainActor
    func load() {
        task?.cancel()

        task = Task {
            do {
                image = try await source.load()
            } catch {
                logger.error("\(error.localizedDescription)")
            }
        }
    }

    @MainActor
    func onMagnificationGestureChanged(value: CGFloat) {
        currentZoom = value
    }

    @MainActor
    func onMagnificationGestureEnded() {
        totalZoom += currentZoom
        currentZoom = 0
    }

    @MainActor
    func onDragGestureChanged(value: CGSize) {
        currentOffset = value
    }

    @MainActor
    func onDragGestureEnded() {
        totalOffset = CGSize(
            width: currentOffset.width + totalOffset.width,
            height: currentOffset.height + totalOffset.height
        )
        currentOffset = .zero
    }

    @MainActor
    func reset() {
        totalZoom = Constants.defaultScale
        totalOffset = Constants.defaultOffset
    }
}
