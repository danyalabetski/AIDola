import SwiftUI

struct LoadingScreen: View {
    @ObservedObject var viewModel: VideoGenerationViewModel
    let backAction: VoidClosure
    let pushToResultAction: VoidClosure
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Button(action: {
                        viewModel.cancelGeneration()
                        backAction()
                    }) {
                        Image(Images.Chat.back.rawValue)
                    }
                    
                    Spacer()
                }
                .padding(.leading, 16)
                
                Spacer()
                
                VStack(spacing: 40) {
                    Image(Images.GenerationVideo.loading.rawValue)
                    
                    VStack(spacing: 8) {
                        Text("Generating...")
                            .foregroundColor(Color.white)
                            .font(.system(size: 20, weight: .semibold))
                        
                        Text("We’re creating the best result for you")
                            .foregroundColor(Color.color_606060)
                            .font(.system(size: 16, weight: .regular))
                    }
                }
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden()
        .onChange(of: viewModel.isGeneratingCompletion) { completed in
            guard completed else { return }
            pushToResultAction()
            viewModel.isGeneratingCompletion = false
        }
    }
}

#Preview {
    LoadingScreen(viewModel: VideoGenerationViewModel(), backAction: {}, pushToResultAction: {})
}
