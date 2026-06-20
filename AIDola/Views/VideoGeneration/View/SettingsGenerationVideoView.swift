import PhotosUI
import SwiftUI

struct SettingsGenerationVideoView: View {
    @ObservedObject var viewModel: VideoGenerationViewModel

    let backAction: VoidClosure
    let pushLoading: VoidClosure

    @State private var selectedPhoto: PhotosPickerItem?

    @State private var isFormatPickerPresented = false
    @State private var isQualityPickerPresented = false

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack(spacing: 24) {
                navigationBar

                VStack(spacing: 16) {
                    templateCarousel

                    HStack {
                        photoSection

                        Spacer()
                    }

                    settingsSection

                    Spacer()

                    createButton
                }
                .padding(.bottom, 16)
            }
            .padding(16)
        }
        .navigationBarBackButtonHidden()
        .task(id: selectedPhoto) {
            guard let selectedPhoto else { return }

            if let data = try? await selectedPhoto.loadTransferable(type: Data.self),
               let image = UIImage(data: data)
            {
                viewModel.selectedImage = image
            }
        }
        .onTapGesture {
            isFormatPickerPresented = false
            isQualityPickerPresented = false
        }
    }
}

private extension SettingsGenerationVideoView {
    var navigationBar: some View {
        ZStack {
            Text(viewModel.selectedTemplate?.name ?? "")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.white)

            HStack {
                Button(action: backAction) {
                    Image(Images.Chat.back.rawValue)
                }

                Spacer()
            }
        }
        .padding(.top, 8)
    }
}

private extension SettingsGenerationVideoView {
    var templateCarousel: some View {
        GeometryReader { geometry in

            let cardWidth: CGFloat = 331
            let spacing: CGFloat = 16
            let sideInset = max((geometry.size.width - cardWidth) / 2, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: spacing) {
                    ForEach(viewModel.filteredTemplates) { template in
                        VideoThumbnailView(
                            url: template.previewSmall,
                            widht: 800,
                            height: 1000
                        )
                        .frame(width: cardWidth, height: 311)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .id(template.id)
                        .offsetPreference(id: template.id)
                    }
                }
                .padding(.horizontal, sideInset)
            }
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                guard let closest = value.min(by: { abs($0.offset) < abs($1.offset) }) else { return }

                if let template = viewModel.filteredTemplates.first(where: { $0.id == closest.id }) {
                    if viewModel.selectedTemplate?.id != template.id {
                        viewModel.selectedTemplate = template
                        print("Selected by scroll:", template.id)
                    }
                }
            }
        }
        .frame(height: 311)
    }
}

private extension SettingsGenerationVideoView {
    var photoSection: some View {
        let selectedImage = viewModel.selectedImage

        return HStack(spacing: 0) {
            PhotosPicker(
                selection: $selectedPhoto,
                matching: .images
            ) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.color_98C6F7,
                                    Color.color_EB5B92
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 1
                        )
                        .frame(width: 100, height: 100)

                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 16)
                            )
                            .overlay(alignment: .topTrailing) {
                                Button(action: {
                                    viewModel.selectedImage = nil
                                }) {
                                    Circle()
                                        .frame(width: 32, height: 32)
                                        .foregroundColor(.white)
                                        .overlay {
                                            Image(systemName: "xmark")
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
                                        }
                                        .padding([.top, .trailing], -12)
                                }
                            }
                    } else {
                        Image(systemName: "plus")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}

private extension SettingsGenerationVideoView {
    var settingsSection: some View {
        VStack(spacing: 8) {
            settingRow(
                title: "Format",
                value: viewModel.selectedFormat.rawValue
            )
            .onTapGesture {
                isQualityPickerPresented = false
                isFormatPickerPresented.toggle()
            }

            settingRow(
                title: "Quality",
                value: viewModel.selectedQuality.rawValue
            )
            .onTapGesture {
                isFormatPickerPresented = false
                isQualityPickerPresented.toggle()
            }
        }
        .overlay(alignment: .topTrailing, content: {
            if isFormatPickerPresented || isQualityPickerPresented {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(Color.color_0B070E)
                    .frame(width: 175, height: 132)
                    .overlay {
                        if isFormatPickerPresented {
                            PopupPicker(
                                selectedItem: $viewModel.selectedFormat,
                                showsFormatIcon: true
                            )
                        } else {
                            PopupPicker(
                                selectedItem: $viewModel.selectedQuality,
                                showsFormatIcon: false
                            )
                        }
                    }
                    .padding(.top, isFormatPickerPresented ? -70 : -25)
            }
        })
    }

    func settingRow(
        title: String,
        value: String
    ) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.white.opacity(0.6))

            Spacer()

            Text(value)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 16)
        .frame(height: 60)
        .background(Color.color_1F191F.opacity(0.8))
        .clipShape(
            RoundedRectangle(cornerRadius: 24)
        )
    }
}

private extension SettingsGenerationVideoView {
    var createButton: some View {
        Button {
            viewModel.startGeneration()
            pushLoading()
        } label: {
            Text("Create")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    viewModel.canCreate
                        ? AnyShapeStyle(
                            LinearGradient(
                                colors: [
                                    Color.color_98C6F7,
                                    Color.color_EB5B92
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        : AnyShapeStyle(Color.color_1F191F)
                )
                .clipShape(Capsule())
        }
        .disabled(!viewModel.canCreate)
        .opacity(viewModel.selectedImage == nil ? 0.4 : 1)
    }
}

#Preview {
    SettingsGenerationVideoView(viewModel: VideoGenerationViewModel(), backAction: {}, pushLoading: {})
}
