import Foundation

struct ChatItem: Decodable, Identifiable {
    let chatId: String
    let title: String?
    let personaId: Int?
    let updatedAt: Date
    let lastMessagePreview: String?

    var id: String { chatId }

    enum CodingKeys: String, CodingKey {
        case chatId = "chat_id"
        case title
        case personaId = "persona_id"
        case updatedAt = "updated_at"
        case lastMessagePreview = "last_message_preview"
    }
}

struct ChatHistoryItem: Decodable {
    let role: String
    let content: String
    let messageSource: String
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case role
        case content
        case messageSource = "message_source"
        case createdAt = "created_at"
    }
}

import Foundation

final class HistoryChatAPIService {

    // MARK: - Private Properties

    private let baseURL = "https://nebulaapps.site/dola"
    private let token = KeysManager.shared.token

    private let userId = KeysManager.shared.userId
    private let appId = Bundle.main.bundleIdentifier ?? ""

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]

        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let value = try container.decode(String.self)

            guard let date = formatter.date(from: value) else {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Invalid date: \(value)"
                )
            }

            return date
        }

        return decoder
    }()

    // MARK: - Public Methods

    func getChats(
        limit: Int? = nil,
        offset: Int = 0
    ) async throws -> [ChatItem] {

        guard var components = URLComponents(
            string: "\(baseURL)/chats"
        ) else {
            throw NetworkError.invalidURL
        }

        components.queryItems = [
            .init(name: "user_id", value: userId),
            .init(name: "app_id", value: appId),
            .init(name: "offset", value: "\(offset)")
        ]

        if let limit {
            components.queryItems?.append(
                .init(name: "limit", value: "\(limit)")
            )
        }

        var request = try makeRequest(from: components)
        request.httpMethod = "GET"

        let (data, response) = try await URLSession.shared.data(for: request)

        try validate(response)

        return try decoder.decode([ChatItem].self, from: data)
    }

    func getChat(
        chatId: String,
        limit: Int? = nil,
        offset: Int = 0
    ) async throws -> [ChatHistoryItem] {

        guard var components = URLComponents(
            string: "\(baseURL)/chats/\(chatId)/messages"
        ) else {
            throw NetworkError.invalidURL
        }

        components.queryItems = [
            .init(name: "user_id", value: userId),
            .init(name: "app_id", value: appId),
            .init(name: "offset", value: "\(offset)")
        ]

        if let limit {
            components.queryItems?.append(
                .init(name: "limit", value: "\(limit)")
            )
        }

        var request = try makeRequest(from: components)
        request.httpMethod = "GET"

        let (data, response) = try await URLSession.shared.data(for: request)

        try validate(response)

        return try decoder.decode([ChatHistoryItem].self, from: data)
    }
}

// MARK: - Private Methods

private extension HistoryChatAPIService {

    func makeRequest(from components: URLComponents) throws -> URLRequest {
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)

        request.setValue(
            "Bearer \(token)",
            forHTTPHeaderField: "Authorization"
        )

        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        return request
    }

    func validate(_ response: URLResponse) throws {
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard 200...299 ~= response.statusCode else {
            throw NetworkError.serverError(response.statusCode)
        }
    }
}
