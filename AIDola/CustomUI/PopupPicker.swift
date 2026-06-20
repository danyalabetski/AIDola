import SwiftUI

enum FormatOrQuality {
    case format, quality
}

struct PopupPicker<Item: PopupSelectable>: View {
    @Binding var selectedItem: Item
    let showsFormatIcon: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .foregroundColor(Color.color_0B070E)
            .frame(width: 175, height: CGFloat(Item.allCases.count) * 40 + 16)
            .overlay {
                VStack(spacing: 0) {
                    ForEach(Array(Item.allCases), id: \.self) { item in

                        PopupRow(
                            item: item,
                            selectedItem: $selectedItem,
                            showsFormatIcon: showsFormatIcon
                        )

                        if item != Array(Item.allCases).last {
                            separator
                        }
                    }
                }
                .padding(.vertical, 8)
            }
    }

    private var separator: some View {
        Rectangle()
            .fill(Color.white.opacity(0.15))
            .frame(height: 1)
            .padding(.horizontal, 8)
    }
}

struct PopupRow<Item: PopupSelectable>: View {
    let item: Item
    @Binding var selectedItem: Item

    var showsFormatIcon = false

    var body: some View {
        HStack {
            Text(item.title)
                .foregroundStyle(
                    selectedItem == item
                        ? LinearGradient(
                            colors: [
                                Color.color_98C6F7,
                                Color.color_EB5B92
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        : LinearGradient(
                            colors: [.white, .white],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                )

            Spacer()

            if showsFormatIcon,
               let format = item as? VideoFormat
            {
                FormatIconView(
                    format: format,
                    selectedFormat: selectedItem as! VideoFormat
                )
            }
        }
        .padding(.horizontal, 12)
        .frame(height: 40)
        .contentShape(Rectangle())
        .onTapGesture {
            selectedItem = item
        }
    }
}

private struct FormatIconView: View {
    let format: VideoFormat
    let selectedFormat: VideoFormat

    var body: some View {
        ZStack {
            switch format {
            case .portrait:
                exampleFomat(width: 22, height: 14)
            case .landscape:
                exampleFomat(width: 13, height: 20)
            case .square:
                exampleFomat(width: 20, height: 20)
            }
        }
    }

    private func exampleFomat(width: CGFloat, height: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 2)
            .stroke(
                selectedFormat == format
                    ? LinearGradient(
                        colors: [
                            Color.color_98C6F7,
                            Color.color_EB5B92
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    : LinearGradient(
                        colors: [.white, .white],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                lineWidth: 1
            )
            .frame(width: width, height: height)
    }
}
