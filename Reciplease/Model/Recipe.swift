//
//  Recipe.swift
//  Reciplease
//
//  Created by Lei et Matthieu on 06/11/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import Foundation

struct Recipe: Decodable {
    let matches : [Matches]
    
    struct Matches: Decodable {
        let imageUrlsBySize : ImageUrlsBySize
        let ingredients : [String]
        let recipeName : String
        let totalTimeInSeconds : Int
        let rating : Int
    }
    struct ImageUrlsBySize: Decodable {
        let UrlImage : String
    }
}
