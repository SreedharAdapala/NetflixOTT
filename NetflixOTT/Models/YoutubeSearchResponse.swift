//
//  YoutubeSearchResponse.swift
//  NetflixOTT
//
//  Created by Perennials on 12/02/24.
//

import Foundation


struct YoutubeSearchResponse: Decodable {
    let items: [VideoElement]
}


struct VideoElement: Decodable {
    let id: IdVideoElement
}


struct IdVideoElement: Decodable {
    let kind: String
    let videoId: String
}
