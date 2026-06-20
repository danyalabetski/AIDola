import Combine

final class HistoryVideoViewModel: ObservableObject {
    @Published var videos: [VideoEntity] = []

    private let coreDataManager = CoreDataManager()

    // MARK: - Load

    func loadVideos() {
        videos = coreDataManager.fetchVideos()
    }

    // MARK: - Refresh (optional)

    func refresh() {
        loadVideos()
    }
}
