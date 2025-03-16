//
//  LabelExtension.swift
//  GOW
//
//  Created by ruizvi | VIDAL RUIZ VARGAS on 08/03/25.
//

import UIKit

extension UILabel{
    func setCustomFont(fontName: String, size: CGFloat, UIFontStyle textStyle: UIFont.TextStyle) {
        guard let customFont = UIFont(name: fontName, size: size) else {
            self.font = UIFont.systemFont(ofSize: size)
            return
        }
        self.font = customFont
        let fontMetrics = UIFontMetrics(forTextStyle: textStyle);
        self.font = fontMetrics.scaledFont(for: customFont);
        self.adjustsFontForContentSizeCategory = true
        
        
    }
}
