import Foundation
import UIKit

extension UIImage {
    
    func scaleToFillSize(size: CGSize, equalRatio: Bool = false, scale: CGFloat = 0) -> UIImage? {
        if __CGSizeEqualToSize(self.size, size) {
            return self
        }
        let scale = scale == 0 ? self.scale : scale
        let rect: CGRect
        if size.width / size.height != width / height && equalRatio {
            let scale = size.width / width
            var scaleHeight = scale * height
            var scaleWidth = size.width
            if scaleHeight < size.height {
                scaleWidth = size.height / scaleHeight * size.width
                scaleHeight = size.height
            }
            rect = CGRect(
                x: -(scaleWidth - size.height) * 0.5,
                y: -(scaleHeight - size.height) * 0.5,
                width: scaleWidth,
                height: scaleHeight
            )
        } else {
            rect = CGRect(origin: .zero, size: size)
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func resetSize(maxImageLength: CGFloat, maxSizeKB: CGFloat) -> Data {
        var maxSize = maxSizeKB
        var maxImageSize = maxImageLength
        if (maxSize <= 0.0) {
            maxSize = 1024.0;
        }
        if (maxImageSize <= 0.0)  {
            maxImageSize = 1024.0;
        }
        // 先调整分辨率
        var newSize = CGSize.init(width: self.size.width, height: self.size.height)
        let tempHeight = newSize.height / maxImageSize;
        let tempWidth = newSize.width / maxImageSize;
        if (tempWidth > 1.0 && tempWidth > tempHeight) {
            newSize = CGSize.init(width: self.size.width / tempWidth, height: self.size.height / tempWidth)
        }
        else if (tempHeight > 1.0 && tempWidth < tempHeight){
            newSize = CGSize.init(width: self.size.width / tempHeight, height: self.size.height / tempHeight)
        }
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        var imageData = newImage!.jpegData(compressionQuality: 1.0)
        var sizeOriginKB : CGFloat = CGFloat((imageData?.count)!) / 1024.0;
        // 调整大小
        var resizeRate = 0.9;
        while (sizeOriginKB > maxSize && resizeRate > 0.1) {
            imageData = newImage!.jpegData(compressionQuality: CGFloat(resizeRate));
            sizeOriginKB = CGFloat((imageData?.count)!) / 1024.0;
            resizeRate -= 0.1;
        }
        return imageData!
   }
    
}

