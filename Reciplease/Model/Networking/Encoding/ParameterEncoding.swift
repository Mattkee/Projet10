//
//  ParameterEncoding.swift
//  Reciplease
//
//  Created by Lei et Matthieu on 09/11/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import Foundation

public typealias Parameters = [String:Any]

// MARK: - Encode Paramaters Protocol
public protocol ParameterEncoder {
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

// MARK: - Manages Encode issues
public enum NetworkError : String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
}
