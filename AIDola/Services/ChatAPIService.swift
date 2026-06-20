import Foundation

struct SendMessageRequest: Encodable {
    let message: String
    let personaId: String?
    let additionalPrompt: String?

    enum CodingKeys: String, CodingKey {
        case message
        case personaId = "persona_id"
        case additionalPrompt = "additional_prompt"
    }
}

enum ChatLocale: String {
    case en
    case zhHans = "zh-Hans"
    case zhHant = "zh-Hant"
    case esMX = "es-MX"
    case pt
}

struct SendMessageResponse: Decodable {
    let chatId: String
    let assistantMessage: String

    enum CodingKeys: String, CodingKey {
        case chatId = "chat_id"
        case assistantMessage = "assistant_message"
    }
}

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(Int)
    case decoding(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"

        case .invalidResponse:
            return "Invalid response"

        case .serverError(let code):
            return "Server error: \(code)"

        case .decoding(let error):
            return error.localizedDescription
        }
    }
}

final class ChatAPIService {
    // MARK: - Private Properties

    private let baseURL = "https://nebulaapps.site/dola"
    private let token = KeysManager.shared.token
    private let userId = KeysManager.shared.userId
    private let appId = Bundle.main.bundleIdentifier ?? ""

    // MARK: - Public Methods

    func sendMessage(
        chatId: String,
        message: String,
        locale: ChatLocale = .en,
        personaId: String? = nil,
        additionalPrompt: String? = nil
    ) async throws -> SendMessageResponse {
        guard var components = URLComponents(
            string: "\(baseURL)/chats/\(chatId)/messages"
        ) else {
            throw NetworkError.invalidURL
        }

        components.queryItems = [
            .init(name: "user_id", value: userId),
            .init(name: "app_id", value: appId),
            .init(name: "locale", value: locale.rawValue)
        ]

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)

        request.httpMethod = "POST"

        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        request.setValue(
            locale.rawValue,
            forHTTPHeaderField: "Accept-Language"
        )

        request.setValue(
            "Bearer \(token)",
            forHTTPHeaderField: "Authorization"
        )

        request.httpBody = try JSONEncoder().encode(
            SendMessageRequest(
                message: message,
                personaId: personaId,
                additionalPrompt: additionalPrompt
            )
        )

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard 200 ... 299 ~= response.statusCode else {
            throw NetworkError.serverError(response.statusCode)
        }

        do {
            return try JSONDecoder().decode(
                SendMessageResponse.self,
                from: data
            )
        } catch {
            throw NetworkError.decoding(error)
        }
    }
}
