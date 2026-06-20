import Combine
import Foundation
import UIKit

@MainActor
final class VideoGenerationViewModel: ObservableObject {
    // MARK: - Propertys
    
    private let coreDataManager = CoreDataManager()

    @Published var templates: [VideoTemplate] = []
    @Published var selectedCategory: String = ""

    @Published var selectedTemplate: VideoTemplate?
    @Published var selectedFormat: VideoFormat = .square
    @Published var selectedQuality: VideoQuality = .p1080
    @Published var selectedImage: UIImage?
    @Published var generatedVideoURL: String?
    @Published var isGeneratingCompletion = false

    private var generationTask: Task<Void, Never>?

    func startGeneration() {
        generationTask?.cancel()

        generationTask = Task {
            await generateVideo()
        }
    }

    func cancelGeneration() {
        generationTask?.cancel()
        generationTask = nil
    }

    var canCreate: Bool {
        selectedImage != nil
    }

    var categories: [String] {
        let categories = Array(
            Set(templates.map(\.category))
        ).sorted()

        return categories
    }

    var filteredTemplates: [VideoTemplate] {
        guard !selectedCategory.isEmpty else {
            return templates
        }

        return templates.filter {
            $0.category == selectedCategory
        }
    }

    // MARK: - Methods

    func getTemplates() async {
        do {
            let response = try await GenerationVideoService.shared.getTemplates()

            templates = response.templates
            selectedCategory = categories.first ?? ""

        } catch {
            print("❌ Failed to load templates:", error)
        }
    }

    private func generateVideo() async {
        defer {
            generationTask = nil
        }

        guard let data = selectedImage?.jpegData(compressionQuality: 0.9) else {
            return
        }

        do {
            let response = try await GenerationVideoService.shared.generateVideo(
                prompt: "A cinematic drone shot over snowy mountains",
                imageData: data,
                duration: 5,
                model: "v6",
                quality: selectedQuality.rawValue
            )

            generatedVideoURL = try await GenerationVideoService.shared.waitForVideo(
                id: response.videoId
            )
            
            isGeneratingCompletion = true
            
            guard let urlString = generatedVideoURL else { return }
            coreDataManager.saveToDatabase(urlString: urlString)
            print("Video URL:", generatedVideoURL ?? "URL NIL")

        } catch is CancellationError {
            print("Generation cancelled")

        } catch {
            print("Generate video error:", error)
        }
    }
}
