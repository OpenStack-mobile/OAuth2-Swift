//
//  AccessToken.swift
//  OpenStackID
//
//  Created by Alsey Coleman Miller on 12/16/16.
//  Copyright © 2016 OpenStack. All rights reserved.
//

import Foundation

/// If the access token request is valid and authorized, the
/// authorization server issues an access token and optional refresh token.
///
/// - SeeAlso: [Issuing an Access Token](https://tools.ietf.org/html/rfc6749#section-5)
public struct AccessTokenResponse {
    
    /// [5.1.  Successful Response](https://tools.ietf.org/html/rfc6749#section-5.1)
    ///
    /// The authorization server issues an access token and optional refresh token, and constructs the response.
    ///
    /// For example:
    /// ```
    /// HTTP/1.1 200 OK
    /// Content-Type: application/json;charset=UTF-8
    /// Cache-Control: no-store
    /// Pragma: no-cache
    ///
    /// {
    /// "access_token":"2YotnFZFEjr1zCsicMWpAA",
    /// "token_type":"example",
    /// "expires_in":3600,
    /// "refresh_token":"tGzv3JOkF0XG5Qx2TlKWIA",
    /// "example_parameter":"example_value"
    /// }
    /// ```
    public struct Successful: Response {
        
        /// Parameters returned in the JSON body of the response.
        public enum JSONKey: String {
            
            /// REQUIRED. The access token issued by the authorization server.
            case access_token
            
            /// REQUIRED.  The type of the token issued as described in
            /// [Section 7.1](https://tools.ietf.org/html/rfc6749#section-7.1). 
            ///
            /// Value is case insensitive.
            case token_type
            
            /// RECOMMENDED.  The lifetime in seconds of the access token.  For
            /// example, the value "3600" denotes that the access token will
            /// expire in one hour from the time the response was generated.
            /// If omitted, the authorization server SHOULD provide the
            /// expiration time via other means or document the default value.
            case expires_in
            
            /// OPTIONAL.  The refresh token, which can be used to obtain new
            /// access tokens using the same authorization grant as described in 
            /// [Section 6](https://tools.ietf.org/html/rfc6749#section-6).
            case refresh_token
            
            /// OPTIONAL, if identical to the scope requested by the client;
            /// otherwise, REQUIRED.  The scope of the access token as
            /// described by [Section 3.3](https://tools.ietf.org/html/rfc6749#section-3.3).
            case scope
        }
        
        /// The expected HTTP status code is `200`.
        public static let statusCode: HTTP.StatusCode = .OK
        
        /// The access token issued by the authorization server.
        public var accessToken: String
        
        /// The access token type provides the client with the information
        /// required to successfully utilize the access token to make a protected
        /// resource request (along with type-specific attributes).  The client
        /// MUST NOT use an access token if it does not understand the token type.
        ///
        /// For example, the "bearer" token type defined in [RFC6750](https://tools.ietf.org/html/rfc6750) is utilized
        /// by simply including the access token string in the request:
        ///
        /// ```
        /// GET /resource/1 HTTP/1.1
        /// Host: example.com
        /// Authorization: Bearer mF_9.B5f-4.1JqM
        /// ```
        public var tokenType: String
        
        /// The lifetime in seconds of the access token.
        public var expires: TimeInterval
        
        /// The refresh token, which can be used to obtain new
        /// access tokens using the same authorization grant. 
        public var refreshToken: String?
        
        /// The scope of the access token. 
        public var scope: String?
    }
    
    /// [5.2.  Error Response](https://tools.ietf.org/html/rfc6749#section-5.2)
    ///
    /// The authorization server responds with an HTTP 400 (Bad Request) status code (unless specified otherwise).
    ///
    /// For example:
    /// ```
    /// HTTP/1.1 400 Bad Request
    /// Content-Type: application/json;charset=UTF-8
    /// Cache-Control: no-store
    /// Pragma: no-cache
    ///
    /// {
    /// "error":"invalid_request"
    /// }
    /// ```
    public struct Error: Response, Swift.Error {
        
        public enum JSONKey: String {
            
            /// The error code
            case error, error_description, error_uri
        }
        
        public enum Code: String {
            
            /// The request is missing a required parameter, includes an
            /// unsupported parameter value (other than grant type),
            /// repeats a parameter, includes multiple credentials,
            /// utilizes more than one mechanism for authenticating the
            /// client, or is otherwise malformed.
            case invalidRequest = "invalid_request"
            
            /// Client authentication failed (e.g., unknown client, no
            /// client authentication included, or unsupported
            /// authentication method).  The authorization server MAY
            /// return an HTTP 401 (Unauthorized) status code to indicate
            /// which HTTP authentication schemes are supported.  If the
            /// client attempted to authenticate via the "Authorization"
            /// request header field, the authorization server MUST
            /// respond with an HTTP 401 (Unauthorized) status code and
            /// include the "WWW-Authenticate" response header field
            /// matching the authentication scheme used by the client.
            case invalidClient = "invalid_client"
            
            /// The provided authorization grant (e.g., authorization
            /// code, resource owner credentials) or refresh token is
            /// invalid, expired, revoked, does not match the redirection
            /// URI used in the authorization request, or was issued to another client.
            case invalidGrant = "invalid_grant"
            
            /// The authenticated client is not authorized to use this authorization grant type.
            case unauthorizedClient = "unauthorized_client"
            
            /// The authorization grant type is not supported by the authorization server.
            case unsupportedGrantType = "unsupported_grant_type"
            
            /// The requested scope is invalid, unknown, malformed, or
            /// exceeds the scope granted by the resource owner.
            case invalidScope = "invalid_scope"
        }
        
        /// Error code
        public let code: Code
        
        /// Optional Human-readable error description returned from server.
        public let errorDescription: String?
        
        /// A URI identifying a human-readable web page with
        /// information about the error, used to provide the client
        /// developer with additional information about the error.
        public let errorURI: String?
    }
}

public enum AccessTokenGrantType: String {
    
    /// Resource Owner Password Credentials Grant
    case password
    
    /// Client Credentials Grant
    case clientCredentials = "client_credentials"
    
    /// Authorization Code Token
    case authorizationCode = "authorization_code"
}

public protocol GrantRequest: Request {
    
    /// The type of grant for this request.
    static var grant: GrantType { get }
    
    /// The scope of the authorization.
    var scope: String? { get }
}

public protocol GrantResponse: Response {
    
    /// The access token as assigned by the authorization server.
    var accessToken: String { get }
    
    /// Type of token assigned by the authorization server.
    var tokenType: String { get }
    
    /// Number of seconds after which the access token expires, and is no longer valid.
    ///
    /// - Note: Expiration of access tokens is optional.
    var expiration: TimeInterval? { get }
}

public protocol RefreshableGrantResponse: GrantResponse {
    
    /// A refresh token in case the access token can expire.
    ///
    /// The refresh token is used to obtain a new access token once the one returned in this response is no longer valid.
    var refreshToken: String { get }
}

public enum GrantRequestJSONKey: String {
    
    case grant_type, scope
}

public enum GrantResponseJSONKey: String {
    
    case access_token, token_type, expires_in, refresh_token
}

// MARK: - Owner Password Credentials Grant

public struct ResourceOwnerPasswordCredentialsGrantRequest: GrantRequest {
    
    enum JSONKey: String {
        
        case username, password
    }
    
    public static let grant: GrantType = .password
    
    public var scope: String?
    
    /// The username of the resource owner.
    public var username: String
    
    /// The password of the resource owner.
    public var password: String
}

public struct ResourceOwnerPasswordCredentialsGrantResponse: GrantResponse {
    
    public let accessToken: String
    
    public let tokenType: String
    
    public let expiration: TimeInterval?
    
    public let refreshToken: String
}

// MARK: - Client Credentials Grant

public struct ClientCredentialsGrantRequest: GrantRequest {
    
    public static let grant: GrantType = .clientCredentials
    
    public var scope: String?
}

public struct ClientCredentialsGrantResponse: GrantResponse {
    
    public let accessToken: String
    
    public let tokenType: String
    
    public let expiration: TimeInterval?
}

// MARK: - Token Request

public struct TokenRequest: GrantRequest {
    
    enum JSONKey: String {
        
        case client_id, client_secret, code, redirect_uri
    }
    
    public static let grant: GrantType = .authorizationCode
    
    /// The client application's id.
    public var clientIdentifier: String
    
    /// The client application's client secret.
    public var clientSecret: String
    
    /// The authorization code received by the authorization server.
    public var code: String
    
    /// Required, if the request URI was included in the authorization request. Must be identical then.
    public var redirectURI: String?
}

public struct TokenResponse: GrantResponse {
    
    public let accessToken: String
    
    public let tokenType: String
    
    public let expiration: TimeInterval?
    
    public let refreshToken: String
}
