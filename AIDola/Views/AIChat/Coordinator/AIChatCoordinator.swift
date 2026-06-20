//import Combine
//import SwiftUI
//
//class AIChatCoordinator: BaseCoordinator<Page, Sheet, FullScreenCover> {
//    @Published var isShouldShowTabBar: Bool = true
//    
//    lazy var aiChatViewModel = AIChatViewModel()
//
//    override func build(sheet: Sheet) -> AnyView {
//        switch sheet {
//        case .empty:
//            AnyView(EmptyView())
//        }
//    }
//
//    override func build(fullScreenCover: FullScreenCover) -> AnyView {
//        switch fullScreenCover {
//        case .empty:
//            AnyView(EmptyView())
//        }
//    }
//
//    override func build(page: Page) -> AnyView {
//        switch page {
//        case .empty:
//            AnyView(EmptyView())
//        }
//    }
//
//    @ViewBuilder
//    override func build(tab: Tab) -> AnyView {
//        AnyView(
//            AIChatView(viewModel: aiChatViewModel)
//        )
//    }
//}
