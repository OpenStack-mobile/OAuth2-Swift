//
//  ErrorResponse.swift
//  OAuth2
//
//  Created by Alsey Coleman Miller on 12/22/16.
//  Copyright © 2016 OpenStack. All rights reserved.
//

/// OAuth2 Error Response
public protocol ErrorResponse: Response, Error {
    
    associatedtype Code: ErrorCode
    
    /// Error code
    var code: Code { get }
    
    /// Optional Human-readable error description returned from server.
    var errorDescription: String? { get }
    
    /// A URI identifying a human-readable web page with
    /// information about the error, used to provide the client
    /// developer with additional information about the error.
    var errorURI: String? { get }
}

/// OAuth2 Error Response Code
public protocol ErrorCode: RawRepresentable {
    
    init?(rawValue: String)
    
    var rawValue: String { get }
}

/// OAuth2 Error Response Parameter
public enum ErrorResponseParameter: String {
    
    /// Required. Must be one of a set of predefined error codes.
    case error
    
    /// Optional. A human-readable UTF-8 encoded text describing the error. Intended for a developer, not an end user.
    case error_description
    
    /// Optional. A URI pointing to a human-readable web page with information about the error.
    case error_uri
}
