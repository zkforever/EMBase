import UIKit

extension UIImage {
    func resizeImage(_ size:CGSize) -> UIImage? {
        //UIGraphicsBeginImageContextWithOptions(size,false,UIScreen.main.scale);
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let retImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return retImage;
    }
    
    func scaleImage(scale:CGFloat) -> UIImage? {
        let size = CGSize(width: self.size.width * scale, height: self.size.height * scale)
        return resizeImage(size)
    }
    
    func scaleAndCropImage(to newSize: CGSize) -> UIImage {
        let aspectWidth  = newSize.width/size.width
        let aspectHeight = newSize.height/size.height
        let aspectRatio = max(aspectWidth, aspectHeight)
        
        var scaledImageRect = CGRect.zero
        scaledImageRect.size.width  = size.width * aspectRatio
        scaledImageRect.size.height = size.height * aspectRatio
        scaledImageRect.origin.x    = (newSize.width - size.width * aspectRatio) / 2.0
        scaledImageRect.origin.y    = (newSize.height - size.height * aspectRatio) / 2.0
        
        UIGraphicsBeginImageContext(newSize)
        draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
    
    func crop(newRect : CGRect) -> UIImage {
        let ratio = newRect.size.width / newRect.size.height
        
        var newSize:CGSize!
        if size.width/size.height > ratio {
            newSize = CGSize(width: size.height * ratio, height: size.height)
        }else{
            newSize = CGSize(width: size.width, height: size.width / ratio)
        }
        ////图片绘制区域
        var rect = CGRect.zero
        rect.size.width  = size.width
        rect.size.height = size.height
        rect.origin.x    = 0
        rect.origin.y    = (newSize.height - size.height ) / 2 + newRect.origin.y
        
        //绘制并获取最终图片
        UIGraphicsBeginImageContext(newSize)
        draw(in: rect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
    
    
    func imageByAlpha(alpha:CGFloat)-> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        let ctx = UIGraphicsGetCurrentContext()
        let area = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height)
        if let ctx = ctx {
            ctx.scaleBy(x: 1, y: -1)
            ctx.translateBy(x: 0, y: -area.size.height)
            ctx.setBlendMode(.multiply)
            ctx.setAlpha(alpha)
            if let cgimg = self.cgImage {
                ctx.draw(cgimg, in: area)
            }
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return img
        }
        return nil
    }
    
//    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
//        let rect = CGRect(origin: .zero, size: size)
//        UIGraphicsBeginImageContext(rect.size)
//        color.setFill()
//        UIRectFill(rect)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        guard let cgImage = image?.cgImage else { return nil }
//        self.init(cgImage: cgImage)
//    }
    
}
