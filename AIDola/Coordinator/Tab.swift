import SwiftUI

// MARK: - enum Tab

enum Tab: String, Identifiable, CaseIterable {
    case main

    var id: String {
        self.rawValue
    }

    var titleAndIcon: (title: String, icon: String) {
        switch self {
        case .main:
            (TitleAndIconForTab.main.title, TitleAndIconForTab.main.image)
        }
    }

    static func convert(from: String) -> Self? {
        return Tab.allCases.first { tab in
            tab.rawValue.lowercased() == from.lowercased()
        }
    }
}

// MARK: - enum TitleAndIconForTab

enum TitleAndIconForTab: String, Identifiable {
    case main

    var title: String {
        switch self {
        case .main:
            "home"
        }
    }

    var image: String {
        switch self {
        case .main:
            ""
        }
    }

    var id: String {
        self.rawValue
    }
}

// MARK: - enum Page

enum Page: String, Identifiable {
    case chat, historyChat, generationVideo, settingsGenerationVideoView, loadingScreen, resultView, historyVideoView

    var id: String {
        self.rawValue
    }
}

// MARK: - enum Sheet

enum Sheet: String, Identifiable {
    case empty

    var id: String {
        self.rawValue
    }
}

// MARK: - enum FullScreenCover

enum FullScreenCover: String, Identifiable {
    case paywall

    var id: String {
        self.rawValue
    }
}
