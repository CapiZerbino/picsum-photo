//
//  URLRequest.swift
//  picsum
//
//  Created by Tieu Viet Trong Nghia on 26/8/24.
//

import Foundation

extension URLRequest {
    var curlString: String {
        guard let url = url else { return "" }

        var baseCommand = "curl '\(url.absoluteString)'"

        if httpMethod == "HEAD" {
            baseCommand += " --head"
        }

        var command = [baseCommand]

        if let method = httpMethod, method != "GET" && method != "HEAD" {
            command.append("-X \(method)")
        }

        if let headers = allHTTPHeaderFields {
            for (key, value) in headers {
                command.append("-H '\(key): \(value)'")
            }
        }

        if let body = httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            command.append("-d '\(bodyString)'")
        }

        return command.joined(separator: " \\\n\t")
    }
}
