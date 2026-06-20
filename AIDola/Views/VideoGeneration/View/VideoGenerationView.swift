import SwiftUI

struct VideoGenerationView: View {
    // MARK: - Propertys

    @ObservedObject var viewModel: VideoGenerationViewModel

    let backAction: VoidClosure
    let pushHistoryAction: VoidClosure
    let pushToGenerationVideo: VoidClosure

    @State private var showPermissionAlert = false

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    // MARK: - View

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack(spacing: 20) {
                NavigationBar(
                    image: Images.GenerationVideo.aiVideoLogo.rawValue,
                    title: "AI Video",
                    dateString: "",
                    backAction: backAction,
                    historyAction: pushHistoryAction
                )
                .padding(.horizontal, 16)

                categorySection
                    .padding(.top, 24)

                ScrollView(showsIndicators: false) {
                    LazyVGrid(
                        columns: columns,
                        spacing: 16
                    ) {
                        ForEach(viewModel.filteredTemplates) { template in
                            VideoTemplateCard(template: template)
                                .onTapGesture {
                                    Task {
                                        let status = await PhotoLibraryManager.shared.requestAccess()

                                        switch status {
                                        case .granted, .limited:
                                            print("Photo successfully")
                                            viewModel.selectedTemplate = template
                                            pushToGenerationVideo()
                                        case .denied:
                                            showPermissionAlert = true
                                        }
                                    }
                                }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding([.bottom, .top], 24)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .task {
            await viewModel.getTemplates()
        }
        .alert(
            "Allow access to photos?",
            isPresented: $showPermissionAlert
        ) {
            Button("Allow") {
                PhotoLibraryManager.shared.openSettings()
            }

            Button("Cancel", role: .cancel) {
                backAction()
            }
        } message: {
            Text("To upload an image, the app needs access to your photo gallery.")
        }
    }
}

private extension VideoGenerationView {
    var categorySection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(viewModel.categories, id: \.self) { category in
                    Button {
                        viewModel.selectedCategory = category
                    } label: {
                        Text(category)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12.5)
                            .frame(height: 33)
                            .background {
                                if viewModel.selectedCategory == category {
                                    LinearGradient(
                                        colors: [
                                            Color.color_98C6F7,
                                            Color.color_EB5B92
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                } else {
                                    Color.color_1F191F
                                }
                            }
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

struct VideoTemplateCard: View {
    let template: VideoTemplate

    var body: some View {
        ZStack(alignment: .bottom) {
            VideoThumbnailView(url: template.previewSmall, widht: 342, height: 464)
                .frame(width: 171, height: 232)
                .clipShape(
                    RoundedRectangle(cornerRadius: 24)
                )

            Text(template.name)
                .font(.system(size: 16, weight: .regular))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.bottom, 8)
        }
    }
}

struct VideoThumbnailView: View {
    let url: URL
    let widht: CGFloat
    let height: CGFloat

    @State private var image: UIImage?

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                ProgressView()
                    .tint(.white)
            }
        }
        .task(id: url) {
            image = await VideoThumbnailService.shared
                .generateThumbnail(from: url, width: widht, height: height)
        }
        .onDisappear {
            image = nil
        }
    }
}

#Preview {
    VideoGenerationView(viewModel: VideoGenerationViewModel(), backAction: {}, pushHistoryAction: {}, pushToGenerationVideo: {})
}
