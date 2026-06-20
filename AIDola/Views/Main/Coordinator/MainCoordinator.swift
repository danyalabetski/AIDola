import Combine
import SwiftUI

class MainCoordinator: BaseCoordinator<Page, Sheet, FullScreenCover> {
    @Published var selectedTab: Tab = .main
    @Published var isShouldShowTabBar: Bool = true

    lazy var mainViewModel = MainViewModel()
    lazy var aiChatViewModel = AIChatViewModel()
    lazy var chatHistoryViewModel = ChatHistoryViewModel()
    lazy var videoGenerationViewModel = VideoGenerationViewModel()
    lazy var historyVideoViewModel = HistoryVideoViewModel()
    lazy var paywalViewModel = PaywallViewModel()

    override func build(sheet: Sheet) -> AnyView {
        switch sheet {
        case .empty:
            AnyView(EmptyView())
        }
    }

    override func build(fullScreenCover: FullScreenCover) -> AnyView {
        switch fullScreenCover {
        case .paywall:
            AnyView(PaywallView(
                viewModel: paywalViewModel,
                closeAction: { [weak self] in
                    self?.dismissFullScreenCover()
                }))
        }
    }

    override func build(page: Page) -> AnyView {
        switch page {
        case .chat:
            AnyView(AIChatView(
                viewModel: aiChatViewModel,
                backAction: { [weak self] in
                    self?.pop()
                },
                pushHistoryAction: { [weak self] in
                    self?.push(.historyChat)
                }))
        case .historyChat:
            AnyView(ChatHistoryView(
                viewModel: chatHistoryViewModel,
                backAction: { [weak self] in
                    self?.pop()
                },
                selectChat: { [weak self] chat in
                    guard let self else { return }

                    Task {
                        await self.aiChatViewModel.openChat(chat.chatId)
                    }
                }))
        case .generationVideo:
            AnyView(VideoGenerationView(
                viewModel: videoGenerationViewModel,
                backAction: { [weak self] in
                    self?.pop()
                },
                pushHistoryAction: { [weak self] in
                    self?.push(.historyVideoView)
                },
                pushToGenerationVideo: { [weak self] in
                    self?.push(.settingsGenerationVideoView)
                }))
        case .settingsGenerationVideoView:
            AnyView(SettingsGenerationVideoView(
                viewModel: videoGenerationViewModel,
                backAction: { [weak self] in
                    self?.pop()
                },
                pushLoading: { [weak self] in
                    self?.push(.loadingScreen)
                }))
        case .loadingScreen:
            AnyView(LoadingScreen(
                viewModel: videoGenerationViewModel,
                backAction: { [weak self] in
                    self?.pop()
                },
                pushToResultAction: { [weak self] in
                    self?.push(.resultView)
                }))
        case .resultView:
            AnyView(ResultView(
                viewModel: videoGenerationViewModel,
                backAction: { [weak self] in
                    self?.replaceLast(with: .settingsGenerationVideoView)
                },
                replaceAction: { [weak self] in
                    self?.push(.loadingScreen)
                }))
        case .historyVideoView:
            AnyView(HistoryVideoView(
                viewModel: historyVideoViewModel,
                backAction: { [weak self] in
                    self?.pop()
                }))
        }
    }

    @ViewBuilder
    override func build(tab: Tab) -> AnyView {
        AnyView(
            MainView(
                viewModel: mainViewModel,
                moveToChatAction: { [weak self] in
                    self?.push(.chat)
                },
                moveToGenerationVideo: { [weak self] in
                    self?.push(.generationVideo)
                },
                presentPaywall: { [weak self] in
                    self?.present(fullScreenCover: .paywall)
                })
        )
    }
}
