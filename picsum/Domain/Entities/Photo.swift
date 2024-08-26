//
//  Photo.swift
//  picsum
//
//  Created by Tieu Viet Trong Nghia on 25/8/24.
//

import Foundation

struct Photo: Codable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: String
    let download_url: String
    
    var sizeDescription: String {
        return "\(width)x\(height)"
    }
}
