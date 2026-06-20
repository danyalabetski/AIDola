import SwiftUI
import Combine

class BaseCoordinator<PageType: Hashable, SheetType: Identifiable, FullScreenCoverType: Identifiable>: ObservableObject {
    @Published var path = NavigationPath()
    @Published var sheet: SheetType?
    @Published var fullScreenCover: FullScreenCoverType?

    func push(_ page: PageType) {
        path.append(page)
    }

    func present(sheet: SheetType) {
        self.sheet = sheet
    }

    func present(fullScreenCover: FullScreenCoverType) {
        self.fullScreenCover = fullScreenCover
    }

    func pop() {
        guard path.count > 0 else { return }
        path.removeLast()
    }

    func dismissSheet() {
        sheet = nil
    }

    func dismissFullScreenCover() {
        fullScreenCover = nil
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func replaceLast(with page: PageType) {
        if !path.isEmpty {
            path.removeLast()
        }

        path.append(page)
    }
    
    @ViewBuilder
    func build(sheet: Sheet) -> AnyView {
        AnyView(EmptyView())
    }

    @ViewBuilder
    func build(fullScreenCover: FullScreenCoverType) -> AnyView {
        AnyView(EmptyView())
    }

    @ViewBuilder
    func build(page: PageType) -> AnyView {
        AnyView(EmptyView())
    }

    @ViewBuilder
    func build(tab: Tab) -> AnyView {
        AnyView(EmptyView())
    }
}

