import Combine
import Foundation

struct ChatSection: Identifiable {
    let id = UUID()
    let title: String
    let chats: [ChatItem]
}

@MainActor
final class ChatHistoryViewModel: ObservableObject {

    @Published var sections: [ChatSection] = []
    @Published var isLoading = false

    private let historyService = HistoryChatAPIService()

    func loadChats() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let chats = try await historyService.getChats()
            sections = groupChats(chats)
        } catch {
            print("❌ Failed to load chats:", error)
        }
    }
}

// MARK: - Private Methods

private extension ChatHistoryViewModel {

    func groupChats(_ chats: [ChatItem]) -> [ChatSection] {
        let grouped = Dictionary(
            grouping: chats.sorted { $0.updatedAt > $1.updatedAt }
        ) { chat in
            sectionTitle(for: chat.updatedAt)
        }

        let orderedTitles = ["Today", "Yesterday"]

        let sortedKeys = grouped.keys.sorted { lhs, rhs in
            let leftIndex = orderedTitles.firstIndex(of: lhs) ?? .max
            let rightIndex = orderedTitles.firstIndex(of: rhs) ?? .max

            if leftIndex != rightIndex {
                return leftIndex < rightIndex
            }

            return true
        }

        return sortedKeys.compactMap {
            guard let chats = grouped[$0] else { return nil }

            return ChatSection(
                title: $0,
                chats: chats
            )
        }
    }

    func sectionTitle(for date: Date) -> String {
        let calendar = Calendar.current

        if calendar.isDateInToday(date) {
            return "Today"
        }

        if calendar.isDateInYesterday(date) {
            return "Yesterday"
        }

        return date.formatted(
            .dateTime
                .month(.wide)
                .day()
        )
    }
}
