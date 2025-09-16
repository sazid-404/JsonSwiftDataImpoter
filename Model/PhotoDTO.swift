//
//  PhotoDTO.swift
//  JsonSwiftDataImpoter
//
//  Created by Sazzadul Islam on 9/15/25.
//

import Foundation

struct PhotoDTO: Identifiable, Codable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}
