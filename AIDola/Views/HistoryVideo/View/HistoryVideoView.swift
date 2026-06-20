import AVFoundation
import SwiftUI

struct HistoryVideoView: View {
    @ObservedObject var viewModel: HistoryVideoViewModel
    let backAction: VoidClosure

    var body: some View {
        ZStack(alignment: .top) {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack {
                ZStack {
                    Text("AI Chat History")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(Color.white)

                    HStack {
                        Button(action: backAction) {
                            Image(Images.Chat.back.rawValue)
                        }

                        Spacer()
                    }
                    .padding(.leading, 16)
                }

                if viewModel.videos.isEmpty {
                    ZStack {
                        Image(Images.HistorysVideos.cellsHistory.rawValue)
                            .resizable()
                        Image(Images.HistorysVideos.shadowHistory.rawValue)
                            .resizable()

                        VStack(spacing: 16) {
                            Image(Images.HistorysVideos.logoHistoryVideos.rawValue)

                            VStack(spacing: 8) {
                                Text("No videos yet")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(Color.white)

                                Text("Create your first video to see it here")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(Color.white)
                            }
                        }
                        .padding(.top, 16)
                    }
                } else {
                    let columns = [
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12)
                    ]

                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 8) {
                            ForEach(viewModel.videos, id: \.self) { video in
                                VideoHistoryCell(urlString: video.url ?? "")
                            }
                        }
                        .padding(.horizontal, 8)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct VideoHistoryCell: View {
    let urlString: String

    @State private var thumbnail: UIImage?

    var body: some View {
        ZStack {
            if let thumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .scaledToFill()
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.2))

                ProgressView().tint(.white)
            }
        }
        .frame(height: 180)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .onAppear {
            generateThumbnail()
        }
    }

    private func generateThumbnail() {
        guard thumbnail == nil,
              let url = URL(string: urlString) else { return }

        DispatchQueue.global(qos: .userInitiated).async {
            let asset = AVAsset(url: url)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true

            let time = CMTime(seconds: 1, preferredTimescale: 600)

            do {
                let cgImage = try generator.copyCGImage(at: time, actualTime: nil)
                let image = UIImage(cgImage: cgImage)

                DispatchQueue.main.async {
                    self.thumbnail = image
                }
            } catch {
                print("Thumbnail error:", error)
            }
        }
    }
}

#Preview {
    HistoryVideoView(viewModel: HistoryVideoViewModel(), backAction: {})
}
