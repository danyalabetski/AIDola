import Foundation
import SwiftUI

enum Images {
    enum Main: String {
        case backgroundMain, chatStarsImage, fixImproveWriting, logoMainImage, settings, turnPhotoIntoVideoImage, understandFasterImage, turnPhotoIntoVideoBg, buttonMoveToChat
    }
    
    enum Chat: String {
        case back, historyImage, navBarImage, sendMessage, textFieldImage
    }
    
    enum History: String {
        case starsForCell, logoIfNotHistory
    }
    
    enum GenerationVideo: String {
        case aiVideoLogo, loading, notification
    }
    
    enum HistorysVideos: String {
        case cellsHistory, logoHistoryVideos, shadowHistory
    }
    
    enum Paywall: String {
        case paywallBg, cancel, first, second, third, four
    }
}
