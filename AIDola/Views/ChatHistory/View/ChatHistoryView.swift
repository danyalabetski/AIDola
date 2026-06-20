import SwiftUI

struct ChatHistoryView: View {
    @ObservedObject var viewModel: ChatHistoryViewModel
    let backAction: VoidClosure
    let selectChat: ChatClousre

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack(spacing: 24) {
                navBar(backAction: backAction)

                Spacer()
                if viewModel.sections.isEmpty {
                    VStack(spacing: 8) {
                        VStack(spacing: 16) {
                            Image(Images.History.logoIfNotHistory.rawValue)

                            Text("No chats yet")
                                .foregroundColor(Color.white)
                                .font(.system(size: 28, weight: .bold))
                        }

                        Text("Start a conversation to see\nyour history here")
                            .foregroundColor(Color.white.opacity(0.5))
                            .font(.system(size: 16, weight: .regular))
                            .multilineTextAlignment(.center)
                    }
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(
                            alignment: .leading,
                            spacing: 32
                        ) {
                            ForEach(viewModel.sections) { section in
                                VStack(
                                    alignment: .leading,
                                    spacing: 16
                                ) {
                                    Text(section.title)
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.white)

                                    ForEach(section.chats) { chat in
                                        ChatHistoryCell(chat: chat)
                                            .onTapGesture {
                                                print("Chat: - \(chat)")
                                                selectChat(chat)
                                                backAction()
                                            }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .task {
            await viewModel.loadChats()
        }
    }

    private func navBar(
        backAction: @escaping VoidClosure
    ) -> some View {
        ZStack {
            Text("AI Chat History")
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .semibold))

            HStack {
                Button(action: backAction) {
                    Image(Images.Chat.back.rawValue)
                }

                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 56)
    }
}

struct ChatHistoryCell: View {
    let chat: ChatItem

    var body: some View {
        HStack(spacing: 16) {
            Image(Images.History.starsForCell.rawValue)

            VStack(alignment: .leading, spacing: 4) {
                Text(chat.title ?? "")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)

                Text(
                    chat.updatedAt.formatted(
                        .dateTime
                            .hour()
                            .minute()
                    )
                )
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.5))
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .frame(height: 78)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.color_1F191F.opacity(0.7))
        )
    }
}

#Preview {
    ChatHistoryView(viewModel: ChatHistoryViewModel(), backAction: {}, selectChat: { _ in })
}
