import OSLog
import SwiftUI

class PictureViewModel: ObservableObject {
    private let logger = Logger(subsystem: "PictureViewModel", category: "VM")
    private var task: Task<Void, Never>?

    let sources: [PictureSource]

    @Published var images: [Image]

    init(sources: [PictureSource]) {
        self.sources = sources
        self.task = nil
        self.images = []
    }

    deinit {
        task?.cancel()
    }

    @MainActor
    func load() {
        task?.cancel()

        task = Task {
            for source in sources.prefix(5) {
                do {
                    if let loadedImage = try await source.load() {
                        DispatchQueue.main.async { [weak self] in
                            self?.images.append(loadedImage)
                        }
                    }
                } catch {
                    logger.error("\(error.localizedDescription)")
                }
            }
        }
    }
}
