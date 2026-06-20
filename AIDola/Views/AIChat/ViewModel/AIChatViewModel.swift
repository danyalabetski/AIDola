import Combine
import Foundation

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
    let isLoading: Bool
}

extension ChatMessage {
    static func user(_ text: String) -> Self {
        .init(text: text, isUser: true, isLoading: false)
    }

    static func assistant(_ text: String) -> Self {
        .init(text: text, isUser: false, isLoading: false)
    }

    static var loading: Self {
        .init(text: "", isUser: false, isLoading: true)
    }
}

@MainActor
final class AIChatViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var textFromTF = ""
    @Published var messages: [ChatMessage] = []

    // MARK: - Private Properties

    private let chatService = ChatAPIService()
    private let historyService = HistoryChatAPIService()

    private(set) var chatId: String
    
    init(chatId: String = UUID().uuidString) {
        self.chatId = chatId
    }

    // MARK: - Public Methods

    func sendMessage() {
        let text = textFromTF.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !text.isEmpty else { return }

        textFromTF = ""

        messages.append(.user(text))

        let loadingMessage = ChatMessage.loading
        messages.append(loadingMessage)

        Task {
            do {
                let response = try await chatService.sendMessage(
                    chatId: chatId,
                    message: text
                )

                messages.removeAll { $0.id == loadingMessage.id }

                messages.append(
                    .assistant(response.assistantMessage)
                )

            } catch {
                messages.removeAll { $0.id == loadingMessage.id }

                messages.append(
                    .assistant("Something went wrong. Please try again.")
                )

                print("❌ Send message error:", error)
            }
        }
    }
    
    func openChat(_ chatId: String) async {
        self.chatId = chatId
        messages = [.loading]
        print("ID: - \(chatId)")

        do {
            let history = try await historyService.getChat(chatId: chatId)

            messages = history.map {
                ChatMessage(
                    text: $0.content,
                    isUser: $0.role == "user",
                    isLoading: false
                )
            }
        } catch {
            messages = [
                .assistant("Failed to load chat history.")
            ]

            print(error)
        }
    }
}
