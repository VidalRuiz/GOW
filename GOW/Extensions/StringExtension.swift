//
//  StringExtension.swift
//  GOW
//
//  Created by ruizvi | VIDAL RUIZ VARGAS on 08/03/25.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(withComment comment: String) -> String {
        return NSLocalizedString(self, comment: comment)
    }

    func localized(with arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}
