//
//  Gists.swift
//  Notes
//
//  Created by Максим Лисица on 14/08/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import Foundation

struct Gist: Codable {
    let url: String
    let files: [String: GistFile]
}

struct GistFile: Codable {
    let filename: String
    let rawUrl: String
    
    enum CodingKeys: String, CodingKey { // Позволяет использовать названия полей в структуре отличающиеся от названий ключей в JSON
        case filename
        case rawUrl = "raw_url"
    }
}
