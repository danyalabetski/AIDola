import CoreData

final class CoreDataManager {
    private let context = CoreDataStack.shared.persistentContainer.viewContext

    // MARK: - Save

    func saveToDatabase(urlString: String) {
        let entity = VideoEntity(context: context)
        entity.url = urlString

        saveContext()
    }

    // MARK: - Fetch

    func fetchVideos() -> [VideoEntity] {
        let request: NSFetchRequest<VideoEntity> = VideoEntity.fetchRequest()

        do {
            return try context.fetch(request)
        } catch {
            print("Fetch error:", error)
            return []
        }
    }

    // MARK: - Private

    private func saveContext() {
        guard context.hasChanges else { return }

        do {
            try context.save()
        } catch {
            print("Save error:", error)
        }
    }
}
