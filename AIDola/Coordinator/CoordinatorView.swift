import SwiftUI

struct CoordinatorView: View {
    @State private var selectedTab: Tab = .main

    private let mainCoordinator = MainCoordinator()

    var isSelectedTab: Bool {
        switch selectedTab {
        case .main:
            mainCoordinator.isShouldShowTabBar
        }
    }

    var body: some View {
        ZStack {
            MainTabView(mainCoordinator: mainCoordinator)
            
//            TabView(selection: $selectedTab) {
//                AIChatTabView(aiChatCoordinator: aiChatCoordinator)
//                    .tag(Tab.aiChat)
//            }

//            VStack {
//                Spacer()
//
//                TabBar(
//                    tabs: Tab.allCases,
//                    selectedTab: $selectedTab,
//                    completion: {
//                        switch selectedTab {
//                        case .aiChat:
//                            aiChatCoordinator.popToRoot()
//                        }
//                    }
//                )
//                .opacity(isSelectedTab ? 1 : 0)
//                .animation(.easeInOut(duration: 0.2), value: isSelectedTab)
//                .ignoresSafeArea(.keyboard)
//            }
//            .edgesIgnoringSafeArea(.bottom)
        }
    }
}
