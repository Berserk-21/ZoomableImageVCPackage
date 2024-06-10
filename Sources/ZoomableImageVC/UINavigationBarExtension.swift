//
//  UINavigationBarExtension.swift
//  ZoomableImageViewController
//
//  Created by Berserk on 07/06/2024.
//

import UIKit

extension UINavigationBar {
    
    /// Use this method to set your navigation bar as transparent.
    func becomesTransparent() {
        
        // Set the background image to an empty image
        setBackgroundImage(UIImage(), for: .default)
        
        // Set the shadow image to an empty image
        shadowImage = UIImage()
        
        // Set the bar tint color and tint color to clear
        barTintColor = .clear
        tintColor = .clear
        
        // Set the navigation bar to be translucent
        isTranslucent = true
        
        // Optional: Adjust the title text attributes if needed
        titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}
