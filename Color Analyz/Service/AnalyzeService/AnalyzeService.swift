//
//  AnalyzeService.swift
//  Color Analyz
//
//  Created by Fed on 11.01.2023.
//

import UIKit

protocol AnalyzeServiceProtocol: AnyObject {
    func convertToUIImage(from rawImage: CIImage) -> UIImage
    func findColors(_ image: UIImage) -> Array<(UIColor, Int)>
    func findPopularColors(with colors: Array<(UIColor, Int)>, on image: UIImage) -> [ColorModel]
}

final class AnalyzeService: AnalyzeServiceProtocol {
    func convertToUIImage(from rawImage: CIImage) -> UIImage {
        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(rawImage, from: rawImage.extent)!
        let image = UIImage(cgImage: cgImage)
        return image
    }
    
    // The method i found on the internet: it's analyzing each of pixel on the photo and it returns an array of tuples of Int and UIColor(Int is the number of equal pixels on the photo).
    
    func findColors(_ image: UIImage) -> Array<(UIColor, Int)> {
        let pixelsWide = Int(image.size.width)
        let pixelsHigh = Int(image.size.height)
        guard let pixelData = image.cgImage?.dataProvider?.data else { return [] }
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        var imageColors: [UIColor] = []
        for x in 0..<pixelsWide {
            for y in 0..<pixelsHigh {
                let point = CGPoint(x: x, y: y)
                let pixelInfo: Int = ((pixelsWide * Int(point.y)) + Int(point.x)) * 4
                let color = UIColor(red: CGFloat(data[pixelInfo]) / 255.0,
                                    green: CGFloat(data[pixelInfo + 1]) / 255.0,
                                    blue: CGFloat(data[pixelInfo + 2]) / 255.0,
                                    alpha: CGFloat(data[pixelInfo + 3]) / 255.0)
                imageColors.append(color)
            }
        }
        return imageColors.frequencies()
    }
    
    func findPopularColors(with colors: Array<(UIColor, Int)>, on image: UIImage) -> [ColorModel] {
        var colorArray: [ColorModel] = []
        var range: ClosedRange<Int> = 0...0
        
        if colors.count > 4 {
            range = 0...4
        } else {
            range = 0...colors.count - 1
        }
        
        for index in range {
            let ciColor = CIColor(color: colors[index].0)
            let numberOfPixels = colors[index].1
            let totalNumberOfPixels = Float(image.size.height * image.size.width)
            let colorModel = ColorModel(red: ciColor.red * 255, green: ciColor.green * 255, blue: ciColor.blue * 255, alpha: ciColor.alpha, numberOfPixels: numberOfPixels, totalNumberOfPixels: totalNumberOfPixels)
            colorArray.append(colorModel)
        }
        return colorArray
    }
}
