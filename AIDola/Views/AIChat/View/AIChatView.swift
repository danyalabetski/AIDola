import SwiftUI

struct AIChatView: View {
    // MARK: - Propertys

    @ObservedObject var viewModel: AIChatViewModel
    let backAction: VoidClosure
    let pushHistoryAction: VoidClosure

    @FocusState private var isFocused: Bool

    // MARK: - View

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack {
                RoundedRectangle(cornerRadius: 0)
                    .overlay(alignment: .bottom) {
                        NavigationBar(
                            image: Images.Chat.navBarImage.rawValue,
                            title: "AI Chat",
                            dateString: Date.now.formatted(date: .numeric, time: .omitted),
                            backAction: backAction,
                            historyAction: pushHistoryAction
                        )
                        .padding([.bottom, .horizontal], 16)
                    }
                    .foregroundColor(Color.color_1F191F.opacity(0.4))
                    .frame(height: 129)
                    .edgesIgnoringSafeArea(.all)

                Spacer()

                if viewModel.messages.isEmpty {
                    VStack(spacing: 8) {
                        HStack(spacing: 5) {
                            Text("Your")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .semibold))

                            Text("AI assistant")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            Color.color_98C6F7,
                                            Color.color_EB5B92
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )

                            Text("for anything")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .semibold))
                        }
                    }

                    Text("Ask questions, get answers, and explore ideas\nin seconds")
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.white.opacity(0.5))
                        .font(.system(size: 14, weight: .regular))
                } else {
                    ScrollView {
                        LazyVStack(spacing: 24) {
                            ForEach(viewModel.messages) { message in
                                if message.isLoading {
                                    TypingIndicator()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                } else if message.isUser {
                                    UserMessageBubble(text: message.text)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                } else {
                                    AIMessageBubble(text: message.text)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }

                Spacer()

                RoundedRectangle(cornerRadius: 24)
                    .foregroundColor(Color.color_1F191F)
                    .edgesIgnoringSafeArea(.all)
                    .frame(height: 88)
                    .overlay {
                        HStack {
                            TextField("", text: $viewModel.textFromTF)
                                .focused($isFocused)
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.white)
                                .tint(.white)
                                .padding(.horizontal, 16)
                                .frame(height: 56)
                                .overlay(alignment: .leading) {
                                    if !isFocused || viewModel.textFromTF.isEmpty {
                                        Text("Ask anything...")
                                            .font(.system(size: 16, weight: .regular))
                                            .foregroundColor(.white.opacity(0.5))
                                            .padding(.horizontal, 16)
                                            .allowsHitTesting(false)
                                    }
                                }

                            if viewModel.textFromTF.isEmpty {
                                Button(action: {}) {
                                    Image(Images.Chat.textFieldImage.rawValue)
                                }
                            }

                            if !viewModel.textFromTF.isEmpty {
                                Button(action: {
                                    viewModel.sendMessage()
                                }) {
                                    Image(Images.Chat.sendMessage.rawValue)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
            }
        }
        .navigationBarBackButtonHidden()
        .hideKeyboardOnTap()
    }
}

struct UserMessageBubble: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 16, weight: .regular))
            .foregroundColor(.white)
            .padding(16)
            .frame(alignment: .leading)
            .background(
                LinearGradient(
                    colors: [
                        Color.color_98C6F7,
                        Color.color_EB5B92
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: 24,
                    bottomLeadingRadius: 24,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 24
                )
            )
    }
}

struct AIMessageBubble: View {
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Welcome to the team, Alexander!")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color.color_98C6F7,
                            Color.color_EB5B92
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )

            Text(text)
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.85))
        }
        .padding(24)
        .background(Color.color_1F191F.opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .frame(alignment: .trailing)
    }
}

struct TypingIndicator: View {
    @State private var activeIndex = 0

    private let gradient = LinearGradient(
        colors: [
            Color.color_98C6F7,
            Color.color_EB5B92
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0 ..< 3) { index in
                Circle()
                    .fill(activeIndex == index
                        ? AnyShapeStyle(gradient)
                        : AnyShapeStyle(Color.white.opacity(0.15)))
                    .frame(
                        width: size(for: index),
                        height: size(for: index)
                    )
                    .animation(
                        .easeInOut(duration: 0.2),
                        value: activeIndex
                    )
            }
        }
        .padding(.horizontal, 16)
        .frame(width: 84, height: 51, alignment: .leading)
        .background(Color.color_1F191F.opacity(0.7))
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: 24,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 24,
                topTrailingRadius: 24
            )
        )
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .milliseconds(350))

                activeIndex = (activeIndex + 1) % 3
            }
        }
    }

    private func size(for index: Int) -> CGFloat {
        switch index {
        case 0: return 19
        case 1: return 15
        default: return 11
        }
    }
}

#Preview {
    AIChatView(viewModel: AIChatViewModel(), backAction: {}, pushHistoryAction: {})
}
