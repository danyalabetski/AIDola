import SwiftUI

struct MainView: View {
    // MARK: - Propertys
    
    @ObservedObject var viewModel: MainViewModel
    let moveToChatAction: VoidClosure
    let moveToGenerationVideo: VoidClosure
    let presentPaywall: VoidClosure
    
    private let width = UIScreen.main.bounds.width
    private let height = UIScreen.main.bounds.height
    
    // MARK: - View

    var body: some View {
        ZStack {
            Image(Images.Main.backgroundMain.rawValue)
                .resizable()
                .edgesIgnoringSafeArea(.all)
                
            VStack(spacing: 40) {
                HStack {
                    Spacer()
                    Button(action: presentPaywall) {
                        Image(Images.Main.settings.rawValue)
                    }
                    .padding([.trailing, .top], 16)
                }
                
                VStack(spacing: 24) {
                    Image(Images.Main.logoMainImage.rawValue)
                    
                    Text("Your AI tools,\nready to go")
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 28, weight: .bold))
                              
                    AskAnythingButton(action: moveToChatAction)
                        .padding(.horizontal, 16)
                }
                
                VStack {
                    HStack(spacing: 8) {
                        Image(Images.Main.turnPhotoIntoVideoBg.rawValue)
                            .overlay {
                                VStack(alignment: .leading, spacing: 16) {
                                    Image(Images.Main.turnPhotoIntoVideoImage.rawValue)
                                    
                                    Text("Turn Photo\ninto Video")
                                        .foregroundColor(Color.white)
                                        .font(.system(size: 20, weight: .medium))
                                    
                                    HStack {
                                        Text("Animate")
                                            .foregroundColor(Color.white)
                                            .font(.system(size: 14, weight: .regular))
                                        
                                        Circle()
                                            .frame(width: 4, height: 4)
                                            .foregroundColor(.white)
                                        
                                        Text("Templates")
                                            .foregroundColor(Color.white)
                                            .font(.system(size: 14, weight: .regular))
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: moveToGenerationVideo) {
                                        RoundedRectangle(cornerRadius: 24)
                                            .foregroundColor(Color.white.opacity(0.3))
                                            .frame(height: 32)
                                            .overlay {
                                                HStack(spacing: 8) {
                                                    Text("Ready in seconds")
                                                        .foregroundColor(Color.white)
                                                        .font(.system(size: 12, weight: .regular))
                                                    
                                                    Image(systemName: "play.fill")
                                                        .foregroundColor(Color.white)
                                                }
                                            }
                                    }
                                }
                                .padding(.horizontal, 11.5)
                                .padding(.bottom, 16)
                                .padding(.top, 24)
                            }
                        
                        VStack(spacing: 8) {
                            buttonAIInstruments(
                                image: .fixImproveWriting,
                                title: "Fix & Improve\nWriting",
                                detailFirst: "Rewrite",
                                detailSecond: "Fix grammar")
                            .onTapGesture {
                                presentPaywall()
                            }
                            
                            buttonAIInstruments(
                                image: .understandFasterImage,
                                title: "Understand\nFaster",
                                detailFirst: "Summarize",
                                detailSecond: "Key points")
                            .onTapGesture {
                                presentPaywall()
                            }
                        }
                    }
                }
                Spacer()
            }
        }
    }
    
    private func buttonAIInstruments(
        image: Images.Main,
        title: String,
        detailFirst: String,
        detailSecond: String) -> some View
    {
        RoundedRectangle(cornerRadius: 24)
            .foregroundColor(Color.color_1F191F.opacity(0.7))
            .frame(width: 178, height: 152.5)
            .overlay {
                VStack(alignment: .leading, spacing: 23.5) {
                    Image(image.rawValue)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(title)
                            .foregroundColor(Color.white)
                            .font(.system(size: 16, weight: .medium))
                        
                        HStack {
                            Text(detailFirst)
                                .foregroundColor(Color.white)
                                .font(.system(size: 12, weight: .regular))
                            
                            Circle()
                                .frame(width: 4, height: 4)
                                .foregroundColor(.white)
                            
                            Text(detailSecond)
                                .foregroundColor(Color.white)
                                .font(.system(size: 12, weight: .regular))
                        }
                    }
                }
                .padding(.vertical, 16)
            }
    }
}

#Preview {
    MainView(viewModel: MainViewModel(), moveToChatAction: {}, moveToGenerationVideo: {}, presentPaywall: {})
}
