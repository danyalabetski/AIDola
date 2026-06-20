import AVKit
import PhotosUI
import SwiftUI
import UIKit

struct ResultView: View {
    @ObservedObject var viewModel: VideoGenerationViewModel
    let backAction: VoidClosure
    let replaceAction: VoidClosure

    @State private var isSharePresented = false
    @State private var isDownloading = false
    @State private var shareURL: URL?

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                header

                Spacer()

                videoCard

                Spacer()

                actions
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 24)

            if isDownloading {
                Image(Images.GenerationVideo.notification.rawValue)
                    .overlay(alignment: .bottom) {
                        Text("Video has been saved\nto your gallery")
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.white)
                            .font(.system(size: 16, weight: .regular))
                            .padding(.bottom, 24)
                    }
            }
        }
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $isSharePresented) {
            if let url = shareURL {
                ActivityView(activityItems: [url])
            }
        }
    }
}

// MARK: - Header

private extension ResultView {
    var header: some View {
        ZStack {
            Text("Result")
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(.white)

            HStack {
                Button(action: backAction) {
                    Image(Images.Chat.back.rawValue)
                }
                Spacer()
            }
        }
        .frame(height: 44)
    }
}

// MARK: - Video

private extension ResultView {
    var videoCard: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 32)
                .fill(Color.color_1F191F)
                .overlay {
                    AsyncImage(url: videoURL) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable().scaledToFill()
                        case .failure:
                            Color.color_1F191F
                        case .empty:
                            ProgressView().tint(.white)
                        @unknown default:
                            Color.color_1F191F
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 32))

            replaceButton.padding(16)
        }
        .aspectRatio(9 / 16, contentMode: .fit)
    }

    var videoURL: URL? {
        URL(string: viewModel.generatedVideoURL ?? "")
    }
}

// MARK: - Replace

private extension ResultView {
    var replaceButton: some View {
        Button(action: {
            replaceAction()
            viewModel.startGeneration()
        }) {
            HStack(spacing: 8) {
                Image(systemName: "arrow.triangle.2.circlepath")
                Text("Replace")
            }
            .foregroundStyle(.white)
            .font(.system(size: 17, weight: .medium))
            .padding(.horizontal, 18)
            .frame(height: 44)
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
        }
    }
}

// MARK: - Actions

private extension ResultView {
    var actions: some View {
        HStack(spacing: 16) {
            Button {
                shareVideo()
            } label: {
                Text("Share")
                    .buttonStyle(isGradient: false)
            }

            Button {
                downloadVideo()

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    isDownloading = false
                }
            } label: {
                Text("Download")
                    .buttonStyle(isGradient: true)
            }
        }
    }

    func shareVideo() {
        guard let url = videoURL else { return }
        shareURL = url
        isSharePresented = true
    }

    func downloadVideo() {
        guard let url = videoURL else { return }

        isDownloading = true

        URLSession.shared.downloadTask(with: url) { localURL, _, error in
            guard let localURL, error == nil else {
                DispatchQueue.main.async { self.isDownloading = false }
                return
            }

            PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
                guard status == .authorized || status == .limited else {
                    DispatchQueue.main.async { self.isDownloading = false }
                    return
                }

                PHPhotoLibrary.shared().performChanges {
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: localURL)
                } completionHandler: { _, _ in
                    DispatchQueue.main.async {
                        self.isDownloading = false
                    }
                }
            }
        }.resume()
    }
}

// MARK: - Share Sheet

struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Button Style

private extension View {
    func buttonStyle(isGradient: Bool) -> some View {
        self
            .font(.system(size: 18, weight: .semibold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(background(isGradient: isGradient))
            .clipShape(Capsule())
    }

    @ViewBuilder
    private func background(isGradient: Bool) -> some View {
        if isGradient {
            LinearGradient(
                colors: [Color.color_98C6F7, Color.color_EB5B92],
                startPoint: .leading,
                endPoint: .trailing
            )
        } else {
            Color.color_1F191F
        }
    }
}
