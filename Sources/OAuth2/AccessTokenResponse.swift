//
//  AccessToken.swift
//  OAuth2
//
//  Created by Alsey Coleman Miller on 12/16/16.
//  Copyright © 2016 OpenStack. All rights reserved.
//

import SwiftFoundation

// MARK: - Success Response

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
public protocol AccessTokenResponse: Response {
    
    /// The access token issued by the authorization server.
    var accessToken: String { get }
    
    /// The access token issued by the authorization server.
    var tokenType: String { get }
    
    /// The lifetime in seconds of the access token.
    var expires: TimeInterval? { get }
}

public protocol RefreshableAccessTokenResponse: AccessTokenResponse {
    
    /// The refresh token, which can be used to obtain new
    /// access tokens using the same authorization grant as described in
    /// [Section 6](https://tools.ietf.org/html/rfc6749#section-6).
    var refreshToken: String? { get }
}

/// Parameters returned in the JSON / Form URL Encoding body of the response.
public enum AccessTokenResponseParameter: String {
    
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
}

// MARK: - Error Response

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
public protocol AccessTokenErrorResponse: ErrorResponse {
    
    /// Error code
    var code: AccessTokenErrorCode { get }
}

public enum AccessTokenErrorCode: String, ErrorCode {
    
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

// MARK: - Parsing Implementations

public protocol AccessTokenErrorResponseJSON: AccessTokenErrorResponse, JSONDecodable {
    
    /// Defualt initializer
    init(code: Code, errorDescription: String?, errorURI: String?)
}

public extension AccessTokenErrorResponseJSON {
    
    init?(urlResponse: HTTP.Response) {
        
        guard urlResponse.statusCode == HTTP.StatusCode.BadRequest.rawValue,
            let jsonString = String(UTF8Data: urlResponse.body),
            let json = JSON.Value(string: jsonString)
            else { return nil }
        
        self.init(JSONValue: json)
    }
    
    public init?(JSONValue: JSON.Value) {
        
        guard let JSONObject = JSONValue.objectValue,
            let errorCodeString = JSONObject[ErrorResponseParameter.error.rawValue]?.stringValue,
            let errorCode = Code(rawValue: errorCodeString)
            else { return nil }
        
        let errorDescription = JSONObject[ErrorResponseParameter.error_description.rawValue]?.stringValue
        let errorURI = JSONObject[ErrorResponseParameter.error_uri.rawValue]?.stringValue
        
        self.init(code: errorCode, errorDescription: errorDescription, errorURI: errorURI)
    }
}
