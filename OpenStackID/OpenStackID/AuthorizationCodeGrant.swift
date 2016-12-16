//
//  AuthorizationCodeGrant.swift
//  OpenStackID
//
//  Created by Alsey Coleman Miller on 12/16/16.
//  Copyright © 2016 OpenStack. All rights reserved.
//

import Foundation

/// [Authorization Code Grant](https://tools.ietf.org/html/rfc6749#section-4.1)
///
/// The authorization code grant type is used to obtain both access
/// tokens and refresh tokens and is optimized for confidential clients.
/// Since this is a redirection-based flow, the client must be capable of
/// interacting with the resource owner's user-agent (typically a web
/// browser) and capable of receiving incoming requests (via redirection)
/// from the authorization server.
public struct AuthorizationCodeGrant {
    
    /// [4.1.1.  Authorization Request](https://tools.ietf.org/html/rfc6749#section-4.1.1)
    ///
    /// The client directs the resource owner to the constructed URI using an
    /// HTTP redirection response, or by other means available to it via the
    /// user-agent.
    ///
    /// For example, the client directs the user-agent to make the following
    /// HTTP request using TLS (with extra line breaks for display purposes
    /// only):
    /// 
    /// ```
    /// GET /authorize?response_type=code&client_id=s6BhdRkqt3&state=xyz
    /// &redirect_uri=https%3A%2F%2Fclient%2Eexample%2Ecom%2Fcb HTTP/1.1
    /// Host: server.example.com
    /// ```
    ///
    /// The authorization server validates the request to ensure that all
    /// required parameters are present and valid.  If the request is valid,
    /// the authorization server authenticates the resource owner and obtains
    /// an authorization decision (by asking the resource owner or by
    /// establishing approval via other means).
    ///
    /// When a decision is established, the authorization server directs the
    /// user-agent to the provided client redirection URI using an HTTP
    /// redirection response, or by other means available to it via the
    /// user-agent.
    public struct Request {
        
        /// The client constructs the request URI by adding the following
        /// parameters to the query component of the authorization endpoint URI
        /// using the `"application/x-www-form-urlencoded"` format.
        public enum Parameter: String {
            
            /// REQUIRED.  Value MUST be set to "code".
            case response_type
            
            /// REQUIRED.  The client identifier as described in [Section 2.2](https://tools.ietf.org/html/rfc6749#section-2.2).
            case client_id
            
            /// OPTIONAL.  As described in [Section 3.1.2](https://tools.ietf.org/html/rfc6749#section-3.1.2).
            case redirect_uri
            
            /// OPTIONAL.  The scope of the access request as described by
            /// [Section 3.3](https://tools.ietf.org/html/rfc6749#section-3.3).
            case scope
            
            /// RECOMMENDED.  An opaque value used by the client to maintain
            /// state between the request and callback.  The authorization
            /// server includes this value when redirecting the user-agent back
            /// to the client.  The parameter SHOULD be used for preventing
            /// cross-site request forgery as described in 
            /// [Section 10.12](https://tools.ietf.org/html/rfc6749#section-10.12).
            case state
        }
        
        /// The client identifier.
        public var clientIdentifier: String
        
        /// The redirection endpoint URI 
        /// as described in [Section 3.1.2](https://tools.ietf.org/html/rfc6749#section-3.1.2).
        public var redirectURI: String?
        
        /// The scope of the access request.
        public var scope: String?
        
        /// An opaque value used by the client to maintain state between the request and callback.
        public var state: String?
    }
    
    /// [4.1.2.  Authorization Response](https://tools.ietf.org/html/rfc6749#section-4.1.2)
    public struct Response {
        
        /// [4.1.2.  Authorization Response](https://tools.ietf.org/html/rfc6749#section-4.1.2)
        ///
        /// For example, the authorization server redirects the user-agent by
        /// sending the following HTTP response:
        ///
        /// ```
        /// HTTP/1.1 302 Found
        /// Location: https://client.example.com/cb?code=SplxlOBeZQQYbYS6WxSbIA&state=xyz
        /// ```
        ///
        /// The client MUST ignore unrecognized response parameters.  The
        /// authorization code string size is left undefined by this
        /// specification.  The client should avoid making assumptions about code
        /// value sizes.  The authorization server SHOULD document the size of
        /// any value it issues.
        public struct Success: OpenStackID.Response {
            
            /// If the resource owner grants the access request, the authorization
            /// server issues an authorization code and delivers it to the client by
            /// adding the following parameters to the query component of the
            /// redirection URI using the "application/x-www-form-urlencoded" format
            public enum Parameter: String {
                
                /// REQUIRED.  The authorization code generated by the
                /// authorization server.  The authorization code MUST expire
                /// shortly after it is issued to mitigate the risk of leaks.  A
                /// maximum authorization code lifetime of 10 minutes is
                /// RECOMMENDED.
                /// The client MUST NOT use the authorization code
                /// more than once.  If an authorization code is used more than
                /// once, the authorization server MUST deny the request and SHOULD
                /// revoke (when possible) all tokens previously issued based on
                /// that authorization code.  The authorization code is bound to
                /// the client identifier and redirection URI.
                case code
                
                /// REQUIRED if the "state" parameter was present in the client
                /// authorization request.  The exact value received from the client.
                case state
            }
            
            /// The authorization code.
            public let code: String
            
            /// Required, if present in request. The same value as sent by the client in the state parameter, if any.
            public let state: String?
        }
        
        /// [4.1.2.1.  Error Response](https://tools.ietf.org/html/rfc6749#section-4.1.2.1)
        ///
        /// For example, the authorization server redirects the user-agent by
        /// sending the following HTTP response:
        ///
        /// ```
        /// HTTP/1.1 302 Found
        /// Location: https://client.example.com/cb?error=access_denied&state=xyz
        /// ```
        public struct Error: OpenStackID.Response, Swift.Error {
            
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
        
    }
    
    /// Once an authorization code is obtained, the client can use that code to obtain an access token.
    public struct AccessToken {
        
        /// [4.1.3.  Access Token Request](https://tools.ietf.org/html/rfc6749#section-4.1.3)
        ///
        /// For example, the client makes the following HTTP request using TLS
        /// (with extra line breaks for display purposes only):
        ///
        /// ```
        /// POST /token HTTP/1.1
        /// Host: server.example.com
        /// Authorization: Basic czZCaGRSa3F0MzpnWDFmQmF0M2JW
        /// Content-Type: application/x-www-form-urlencoded
        ///
        /// grant_type=authorization_code&code=SplxlOBeZQQYbYS6WxSbIA
        /// &redirect_uri=https%3A%2F%2Fclient%2Eexample%2Ecom%2Fcb
        /// ```
        /// The authorization server MUST:
        ///
        /// - Require client authentication for confidential clients or for any
        /// client that was issued client credentials (or with other
        /// authentication requirements),
        ///
        /// - Authenticate the client if client authentication is included,
        ///
        /// - Ensure that the authorization code was issued to the authenticated
        /// confidential client, or if the client is public, ensure that the
        /// code was issued to "client_id" in the request,
        ///
        /// - Verify that the authorization code is valid, and
        ///
        /// - Ensure that the "redirect_uri" parameter is present if the
        /// "redirect_uri" parameter was included in the initial authorization
        /// request as described in Section 4.1.1, and if included ensure that
        /// their values are identical.
        public struct Request {
            
            /// The client makes a request to the token endpoint by sending the
            /// following parameters using the "`application/x-www-form-urlencoded`"
            /// format per [Appendix B](https://tools.ietf.org/html/rfc6749#appendix-B)
            /// with a character encoding of UTF-8 in the HTTP request entity-body:
            public enum Parameter: String {
                
                /// REQUIRED.  Value MUST be set to "authorization_code".
                case grant_type
                
                /// REQUIRED.  The authorization code received from the authorization server.
                case code
                
                /// REQUIRED, if the "redirect_uri" parameter was included in the
                /// authorization request as described in Section 4.1.1, and their
                /// values MUST be identical.
                case redirect_uri
                
                /// REQUIRED, if the client is not authenticating with the
                /// authorization server as described in Section 3.2.1.
                case client_id
            }
            
            public static let accessTokenGrantType: AccessTokenGrantType = .authorizationCode
            
            /// The authorization code received from the authorization server.
            public var code: String
            
            /// The redirection endpoint URI
            /// as described in [Section 3.1.2](https://tools.ietf.org/html/rfc6749#section-3.1.2).
            public var redirectURI: String?
            
            /// The client identifier.
            public var clientIdentifier: String
        }
        
        /// [4.1.4.  Access Token Response](https://tools.ietf.org/html/rfc6749#section-4.1.4)
        ///
        /// If the access token request is valid and authorized, the
        /// authorization server issues an access token and optional refresh
        /// token as described in [Section 5.1](https://tools.ietf.org/html/rfc6749#section-5.1).
        /// If the request client authentication failed or is invalid, the authorization server returns
        /// an error response as described in [Section 5.2](https://tools.ietf.org/html/rfc6749#section-5.2).
        ///
        /// An example successful response:
        ///
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
        public typealias Response = AccessTokenResponse
    }
}
