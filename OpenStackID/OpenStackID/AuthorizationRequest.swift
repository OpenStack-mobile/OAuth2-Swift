//
//  Authorization.swift
//  OpenStackID
//
//  Created by Alsey Coleman Miller on 12/16/16.
//  Copyright © 2016 OpenStack. All rights reserved.
//

import Foundation

/// To request an access token, the client obtains authorization from the
/// resource owner.  The authorization is expressed in the form of an
/// authorization grant, which the client uses to request the access
/// token.  OAuth defines four grant types: authorization code, implicit,
/// resource owner password credentials, and client credentials.  It also
/// provides an extension mechanism for defining additional grant types.
///
/// - SeeAlso: [Obtaining Authorization](https://tools.ietf.org/html/rfc6749#section-4)
public struct AuthorizationRequest {
    
    /// The client constructs the request URI by adding the following
    /// parameters to the query component of the authorization endpoint URI
    /// using the `"application/x-www-form-urlencoded"` format.
    public enum Parameter: String {
        
        case response_type, client_id, redirect_uri, scope, state
    }
}


public enum AuthorizationRequestJSONKey: String {
    
    case response_type, client_id, redirect_uri, scope, state
}

public enum AuthorizationResponseJSONKey: String {
    
    case code, state
}

/// The authorization request is sent to the authorization endpoint to obtain an authorization code.
public struct AuthorizationCodeRequest {
    
    
}

/// The authorization response contains the authorization code needed to obtain an access token.
public struct AuthorizationCodeResponse {
    
    public enum JSONKey: String {
        
        /// Required. The authorization code.
        case code
        
        /// Required, if present in request. The same value as sent by the client in the state parameter, if any.
        case state
    }
    
    /// The authorization code.
    public let code: String
    
    /// Required, if present in request. The same value as sent by the client in the state parameter, if any.
    public let state: String
}

public struct AuthorizationErrorResponse: Response, Error {
    
    public enum Parameter: String {
        
        /// Required. Must be one of a set of predefined error codes. See the specification for the codes and their meaning.
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

public struct ImplicitGrantResponse {
    
    
}

