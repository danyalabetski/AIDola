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
        }
    }
}
