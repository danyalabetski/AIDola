import SwiftUI

struct PaywallView: View {
    // MARK: - Propertys
    
    @ObservedObject var viewModel: PaywallViewModel
    let closeAction: VoidClosure
    @State private var isClose = false
    @State private var selected = 0
    
    private let width = UIScreen.main.bounds.width
    private let gradient = LinearGradient(
        colors: [
            Color.color_98C6F7,
            Color.color_EB5B92
        ],
        startPoint: .leading,
        endPoint: .trailing)
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            Image(Images.Paywall.paywallBg.rawValue)
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    if isClose {
                        Button(action: closeAction) {
                            Image(systemName: "xmark")
                                .foregroundColor(Color.white)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.leading, 16)
                
                Spacer()
                
                VStack(spacing: 32) {
                    Text("Create anything\nyou want")
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 34, weight: .bold))
                    
                    VStack(alignment: .leading, spacing: 14) {
                        ForEach(viewModel.imagesAndTitles.indices, id: \.self) { id in
                            let item = viewModel.imagesAndTitles[id]
                            
                            HStack(spacing: 8) {
                                Image(item.image)
                                
                                Text(item.title)
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 16, weight: .medium))
                            }
                        }
                    }
                    
                    VStack(spacing: 12) {
                        subscribeButton(
                            perWeekPrice: "Year $1.27 / weak",
                            price: "$ 69.99 ",
                            isSale: true,
                            isSelected: selected == 0 ? true : false)
                        {
                            selected = 0
                        }
                        
                        subscribeButton(
                            perWeekPrice: "Year $1.27 / weak",
                            price: "$ 69.99 ",
                            isSale: false,
                            isSelected: selected == 1 ? true : false)
                        {
                            selected = 1
                        }
                    }
                    
                    VStack(spacing: 14) {
                        HStack(spacing: 0) {
                            Button(action: {}) {
                                Image(Images.Paywall.cancel.rawValue)
                                
                                Text("Cancel Anytime")
                                    .foregroundColor(Color.color_606060)
                                    .font(.system(size: 12, weight: .regular))
                            }
                        }
                        
                        Button(action: {}) {
                            RoundedRectangle(cornerRadius: 24)
                                .frame(width: width - 32, height: 50)
                                .foregroundStyle(gradient)
                                .overlay {
                                    Text("Unlock now")
                                        .foregroundColor(.white)
                                        .font(.system(size: 16, weight: .semibold))
                                }
                        }
                        
                        HStack {
                            buttons(text: "Privacy Policy", action: {
                                openURL("")
                            })
                            Spacer()
                            buttons(text: "Restore Purchases", action: {})
                            Spacer()
                            buttons(text: "Terms of Use", action: {
                                openURL("")
                            })
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
        }
        .onAppear {
            SubscriptionManager.shared.fetchProducts()
            
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                isClose = true
            }
        }
    }
    
    func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

extension PaywallView {
    func subscribeButton(
        perWeekPrice: String,
        price: String,
        isSale: Bool,
        isSelected: Bool,
        _ action: @escaping VoidClosure) -> some View
    {
        Button(action: action) {
            RoundedRectangle(cornerRadius: 24)
                .foregroundColor(Color.clear)
                .frame(width: width - 32, height: 72)
                .overlay {
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(
                            isSelected
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
                            : AnyShapeStyle(Color.white.opacity(0.3)),
                            lineWidth: 1
                        )
                        .overlay(alignment: .leading) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(perWeekPrice)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .medium))
                                
                                Text(price)
                                    .foregroundColor(Color.color_606060)
                                    .font(.system(size: 14, weight: .regular))
                            }
                            .padding(.leading, 16)
                        }
                        .overlay(alignment: .topTrailing) {
                            if isSale {
                                RoundedRectangle(cornerRadius: 32)
                                    .frame(width: 102, height: 25)
                                    .foregroundStyle(gradient)
                                    .overlay {
                                        Text("SAVE 80%")
                                            .foregroundColor(.white)
                                            .font(.system(size: 14, weight: .medium))
                                    }
                                    .padding([.top, .trailing], 16)
                            }
                        }
                }
        }
    }
}

extension PaywallView {
    func buttons(
        text: String,
        action: @escaping VoidClosure) -> some View
    {
        Button(action: action) {
            Text(text)
                .foregroundColor(Color.color_606060)
                .font(.system(size: 11, weight: .regular))
        }
    }
}

#Preview {
    PaywallView(viewModel: PaywallViewModel(), closeAction: {})
}
