import AVFoundation
import UIKit

final class VideoThumbnailService {
    static let shared = VideoThumbnailService()

    private let cache = NSCache<NSURL, UIImage>()

    private init() {
        cache.countLimit = 50
        cache.totalCostLimit = 30 * 1024 * 1024
    }

    func generateThumbnail(from url: URL, width: CGFloat, height: CGFloat) async -> UIImage? {
        let key = url as NSURL

        if let cached = cache.object(forKey: key) {
            return cached
        }

        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let asset = AVURLAsset(url: url)
                let generator = AVAssetImageGenerator(asset: asset)

                generator.appliesPreferredTrackTransform = true

                generator.maximumSize = CGSize(
                    width: width,
                    height: height
                )

                do {
                    let cgImage = try generator.copyCGImage(
                        at: CMTime(seconds: 0.1, preferredTimescale: 600),
                        actualTime: nil
                    )

                    let image = UIImage(cgImage: cgImage)

                    self.cache.setObject(
                        image,
                        forKey: key,
                        cost: image.jpegData(compressionQuality: 1)?.count ?? 1
                    )

                    continuation.resume(returning: image)

                } catch {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
}
