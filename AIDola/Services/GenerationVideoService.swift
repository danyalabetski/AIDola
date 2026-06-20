import Foundation

final class GenerationVideoService {
    static let shared = GenerationVideoService()

    // MARK: - Private Properties

    private let baseURL = "https://nebulaapps.site/pixverse/api/v1/get_templates"
    private let token = KeysManager.shared.token
    private let userId = KeysManager.shared.userId
    private let appId = Bundle.main.bundleIdentifier ?? ""

    private init() {}

    // MARK: - Public Methods

    func getTemplates() async throws -> VideoTemplatesResponse {
        guard let url = URL(
            string: "\(baseURL)/\(appId)"
        ) else {
            throw NetworkError.invalidURL
        }

        print("URL: - \(url.absoluteString)")

        var request = URLRequest(url: url)

        request.httpMethod = "GET"

        request.setValue(
            "Bearer \(token)",
            forHTTPHeaderField: "Authorization"
        )

        let (data, response) = try await URLSession.shared.data(for: request)

        try validate(response)

        return try JSONDecoder().decode(
            VideoTemplatesResponse.self,
            from: data
        )
    }
}

extension GenerationVideoService {
    func generateVideo(
        prompt: String,
        imageData: Data,
        duration: Int,
        model: String,
        quality: String
    ) async throws -> ImageToVideoResponse {
        var components = URLComponents(
            string: "https://nebulaapps.site/pixverse/api/v1/image2video"
        )

        components?.queryItems = [
            URLQueryItem(name: "user_id", value: userId),
            URLQueryItem(name: "app_id", value: appId)
        ]

        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)

        request.httpMethod = "POST"

        request.setValue(
            "Bearer \(token)",
            forHTTPHeaderField: "Authorization"
        )

        let boundary = UUID().uuidString

        request.setValue(
            "multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type"
        )

        request.httpBody = makeMultipartBody(
            boundary: boundary,
            prompt: prompt,
            duration: duration,
            model: model,
            quality: quality,
            imageData: imageData
        )

//        let (data, response) = try await URLSession.shared.data(for: request)
        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse {
            print("Status code:", httpResponse.statusCode)

            if let body = String(data: data, encoding: .utf8) {
                print("Response body:", body)
            }
        }

        try validate(response)

        try validate(response)

        return try JSONDecoder().decode(
            ImageToVideoResponse.self,
            from: data
        )
    }

    func waitForVideo(id: Int) async throws -> String {
        while true {

            try Task.checkCancellation()

            let response = try await getGenerationStatus(id: id)

            switch response.status.lowercased() {

            case "completed", "success", "done":
                guard let url = response.videoURL else {
                    throw NetworkError.invalidResponse
                }

                return url

            case "failed", "error":
                throw NetworkError.serverError(500)

            default:
                try await Task.sleep(for: .seconds(3))
            }
        }
    }
    private func getGenerationStatus(id: Int) async throws -> VideoGenerationStatusResponse {
        var components = URLComponents(
            string: "https://nebulaapps.site/pixverse/api/v1/status"
        )

        components?.queryItems = [
            URLQueryItem(name: "id", value: "\(id)"),
            URLQueryItem(name: "user_id", value: userId),
            URLQueryItem(name: "app_id", value: appId)
        ]

        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }

        print("Status URL: \(url.absoluteString)")

        var request = URLRequest(url: url)

        request.httpMethod = "GET"

        request.setValue(
            "Bearer \(token)",
            forHTTPHeaderField: "Authorization"
        )

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse {
            print("Status code: \(httpResponse.statusCode)")
            print(String(data: data, encoding: .utf8) ?? "")
        }

        try validate(response)

        return try JSONDecoder().decode(
            VideoGenerationStatusResponse.self,
            from: data
        )
    }
}

private extension GenerationVideoService {
    func makeMultipartBody(
        boundary: String,
        prompt: String,
        duration: Int,
        model: String,
        quality: String,
        imageData: Data
    ) -> Data {
        var body = Data()

        func append(_ string: String) {
            body.append(Data(string.utf8))
        }

        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"prompt\"\r\n\r\n")
        append("\(prompt)\r\n")

        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"duration\"\r\n\r\n")
        append("\(duration)\r\n")

        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"model\"\r\n\r\n")
        append("\(model)\r\n")

        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"quality\"\r\n\r\n")
        append("\(quality)\r\n")

        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"image\"; filename=\"orig.jpg\"\r\n")
        append("Content-Type: image/jpeg\r\n\r\n")

        body.append(imageData)
        append("\r\n")

        append("--\(boundary)--\r\n")

        return body
    }
}

// MARK: - Private Methods

private extension GenerationVideoService {
    func validate(_ response: URLResponse) throws {
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard 200 ... 299 ~= response.statusCode else {
            throw NetworkError.serverError(response.statusCode)
        }
    }
}
