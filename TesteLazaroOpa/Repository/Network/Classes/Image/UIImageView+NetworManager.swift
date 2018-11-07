//
//  UIImageView+NetworManager.swift
//
//  Created by Lacir Moraes Neto, Lazaro on 08/06/18.
//

import UIKit

public extension UIImageView {
    
    public func setImage(url: String, thumb: String? = nil, placeHolder: UIImage? = nil) {

        self.image = placeHolder
        
        if let thumb = thumb {
            UIImage.loadImage(url: thumb) { (image) in
                self.image = image
                UIImage.loadImage(url: url, completion: { (image) in
                    self.image = image
                })
            }
        } else {
            UIImage.loadImage(url: url) { (image) in
                self.image = image
            }
        }
    }
}
