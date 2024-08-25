//
//  APIEndpoints.swift
//  picsum
//
//  Created by Tieu Viet Trong Nghia on 25/8/24.
//

import Foundation

struct APIEndpoints {
    static func photos(page: Int, limit: Int) -> URL? {
        return URL(string: "https://picsum.photos/v2/list?page=\(page)&limit=\(limit)")
    }
}
