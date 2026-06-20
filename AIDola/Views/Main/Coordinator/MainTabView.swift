import SwiftUI

struct MainTabView: View {
    @StateObject var mainCoordinator: MainCoordinator

    var body: some View {
        NavigationStack(path: $mainCoordinator.path) {
            mainCoordinator.build(tab: mainCoordinator.selectedTab)
                .navigationDestination(for: Page.self) { page in
                    mainCoordinator.build(page: page)
                }
                .sheet(item: $mainCoordinator.sheet) { sheet in
                    mainCoordinator.build(sheet: sheet)
                        .presentationDetents([.height(335)])
                }
                .fullScreenCover(item: $mainCoordinator.fullScreenCover) { fullScreenCover in
                    mainCoordinator.build(fullScreenCover: fullScreenCover)
                }
        }
        .environmentObject(mainCoordinator)
    }
}

