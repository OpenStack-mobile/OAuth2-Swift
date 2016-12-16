//
//  AuthorizationResponse.swift
//  OpenStackID
//
//  Created by Alsey Coleman Miller on 12/16/16.
//  Copyright © 2016 OpenStack. All rights reserved.
//

import Foundation

/// Possible response from server
public enum AuthorizationResponse<Success: Response>: Response {
    
    case success(Success)
    
    case error(AuthorizationErrorResponse)
    
    case invalid(HTTPURLResponse)
    
    public init(URLResponse: HTTPURLResponse) {
        
        fatalError()
    }
}

/// Generic Authorization Error Response as defined in
/// [4.1.2.1. (Authorization Code Grant) Error Response](https://tools.ietf.org/html/rfc6749#section-4.1.2.1) and
/// [4.2.2.1. (Implicit Grant) Error Response](https://tools.ietf.org/html/rfc6749#section-4.2.2.1)
///
/// For example, the authorization server redirects the user-agent by
/// sending the following HTTP response:
///
/// ```
/// HTTP/1.1 302 Found
/// Location: https://client.example.com/cb?error=access_denied&state=xyz
/// ```
public struct AuthorizationErrorResponse: Response, Swift.Error {
    
    public enum Parameter: String {
        
        /// Required. Must be one of a set of predefined error codes.
        case error
        
        /// Optional. A human-readable UTF-8 encoded text describing the error. Intended for a developer, not an end user.
        case error_description
        
        /// Optional. A URI pointing to a human-readable web page with information about the error.
        case error_uri
        
        /// Required, if present in authorization request. The same value as sent in the state parameter in the request.
        case state
    }
    
    /// Authorization Error Response Code
    public enum Code: String {
        
        /// The request is missing a required parameter,
        /// includes an invalid parameter value,
        /// includes a parameter more than once,
        /// or is otherwise malformed.
        case invalidRequest = "invalid_request"
        
        /// The client is not authorized to request an access token using this method.
        case unauthorizedClient = "unauthorized_client"
        
        /// The resource owner or authorization server denied the request.
        case accessDenied = "access_denied"
        
        /// The authorization server does not support obtaining an access token using this method.
        case unsupportedResponseType = "unsupported_response_type"
        
        /// The requested scope is invalid, unknown, or malformed.
        case invalidScope = "invalid_scope"
        
        /// The authorization server encountered an unexpected
        /// condition that prevented it from fulfilling the request.
        ///
        /// - Note: This error code is needed because a 500 Internal Server
        /// Error HTTP status code cannot be returned to the client via an HTTP redirect.
        case serverError = "server_error"
        
        /// The authorization server is currently unable to handle
        /// the request due to a temporary overloading or maintenance of the server.
        ///
        /// - Note: This error code is needed because a 503 Service Unavailable HTTP status code
        /// cannot be returned to the client via an HTTP redirect.
        case temporarilyUnavailable = "temporarily_unavailable"
    }
    
    /// Error code
    public let code: Code
    
    /// Optional Human-readable error description returned from server.
    public let errorDescription: String?
    
    /// A URI identifying a human-readable web page with
    /// information about the error, used to provide the client
    /// developer with additional information about the error.
    public let errorURI: String?
    
    /// Required, if present in authorization request.
    /// The same value as sent in the `state` parameter in the request.
    public let state: String?
}
