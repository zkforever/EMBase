import Foundation
import UIKit

extension UIImage {
    
    var width: CGFloat {
        size.width
    }
    var height: CGFloat {
        size.height
    }
    
    public func flip() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        if let ctx = UIGraphicsGetCurrentContext() {
            ctx.scaleBy(x: -1.0, y: 1.0)
            ctx.translateBy(x: -self.size.width, y: 0.0)
        }
        self.draw(in: CGRect(origin: .zero, size: self.size))
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
