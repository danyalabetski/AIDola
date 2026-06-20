import Foundation

struct VideoTemplatesResponse: Decodable {
    let id: Int
    let applicationId: String
    let applicationNumber: Int
    let subscriptionEnabled: Bool
    let templates: [VideoTemplate]

    enum CodingKeys: String, CodingKey {
        case id
        case applicationId = "application_id"
        case applicationNumber = "application_number"
        case subscriptionEnabled = "subscription_enabled"
        case templates
    }
}

struct VideoTemplate: Decodable, Identifiable, Hashable {
    let id: Int
    let templateId: Int64
    let prompt: String
    let name: String
    let category: String
    let templateModel: String
    let qualities: [String]
    let duration: Int
    let isCustom: Bool
    let previewSmall: URL
    let previewLarge: URL
    let isActive: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case templateId = "template_id"
        case prompt
        case name
        case category
        case templateModel = "template_model"
        case qualities
        case duration
        case isCustom = "is_custom"
        case previewSmall = "preview_small"
        case previewLarge = "preview_large"
        case isActive = "is_active"
    }
}

struct ImageToVideoResponse: Decodable {
    let videoId: Int
    let detail: String

    enum CodingKeys: String, CodingKey {
        case videoId = "video_id"
        case detail
    }
}

struct VideoGenerationStatusResponse: Decodable {
    let status: String
    let videoURL: String?

    enum CodingKeys: String, CodingKey {
        case status
        case videoURL = "video_url"
    }
}
