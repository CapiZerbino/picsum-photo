//
//  String+Extensions.swift
//  picsum
//
//  Created by Tieu Viet Trong Nghia on 26/8/24.
//

import Foundation

extension String {
    func removeDiacritics() -> String {
        return self.folding(options: .diacriticInsensitive, locale: .current)
    }
}
