//
//  PhotoObject.swift
//  JsonSwiftDataImpoter
//
//  Created by Sazzadul Islam on 9/15/25.
//

import Foundation
import SwiftData


@Model
class PhotoObject {
    
    var albumId: Int
    @Attribute(.unique) var id: Int
    var title: String
    var url: String
    var thumbnailUrl: String
    
    init(albumId: Int, id: Int, title: String, url: String, thumbnailUrl: String) {
        self.albumId = albumId
        self.id = id
        self.title = title
        self.url = url
        self.thumbnailUrl = thumbnailUrl
    }
    
    convenience init(item: PhotoDTO) {
        self.init(
            albumId: item.albumId,
            id: item.id,
            title: item.title,
            url: item.url,
            thumbnailUrl: item.thumbnailUrl
        )
    }
    
}

