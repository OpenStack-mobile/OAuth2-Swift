//
//  AuthorizationCodeGrant.swift
//  OpenStackID
//
//  Created by Alsey Coleman Miller on 12/16/16.
//  Copyright © 2016 OpenStack. All rights reserved.
//

import SwiftFoundation

/// [Authorization Code Grant](https://tools.ietf.org/html/rfc6749#section-4.1)
///
/// The authorization code grant type is used to obtain both access
/// tokens and refresh tokens and is optimized for confidential clients.
/// Since this is a redirection-based flow, the client must be capable of
/// interacting with the resource owner's user-agent (typically a web
/// browser) and capable of receiving incoming requests (via redirection)
/// from the authorization server.
public struct AuthorizationCodeGrant {
    
    public struct Authorization {
        
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
        public typealias Request = AuthorizationRequest
        
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
        public struct Response: AuthorizationResponse {
            
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
            
            public init?(urlResponse: HTTP.Response) {
                                
                guard urlResponse.statusCode == HTTP.StatusCode.Found.rawValue,
                    let redirectURL = urlResponse.url,
                    let urlComponents = NSURLComponents(url: redirectURL, resolvingAgainstBaseURL: false),
                    let queryItems = urlComponents.queryItems,
                    let code = queryItems.first(where: { $0.name == Parameter.code.rawValue })?.value,
                    let state = queryItems.first(where: { $0.name == Parameter.state.rawValue })?.value
                    else { return nil }
                
                self.code = code
                self.state = state
            }
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
        public struct Request: AccessTokenRequest {
            
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
            
            public static let grantType: AccessTokenGrantType = .authorizationCode
            
            /// The URL of the OAuth2 endpoint for access token grants.
            public var endpoint: String
            
            /// The authorization code received from the authorization server.
            public var code: String
            
            /// The redirection endpoint URI
            /// as described in [Section 3.1.2](https://tools.ietf.org/html/rfc6749#section-3.1.2).
            public var redirectURI: String?
            
            /// The client identifier.
            public var clientIdentifier: String?
            
            public func toURLRequest() -> HTTP.Request {
                                
                guard var urlComponents = URLComponents(string: endpoint)
                    else { fatalError("Invalid URL: \(endpoint)") }
                
                var queryItems = [URLQueryItem]()
                
                queryItems.append(URLQueryItem(name: Parameter.grant_type.rawValue, value: type(of: self).grantType.rawValue))
                
                queryItems.append(URLQueryItem(name: Parameter.code.rawValue, value: clientIdentifier))
                
                if let redirectURI = self.redirectURI {
                    
                    queryItems.append(URLQueryItem(name: Parameter.redirect_uri.rawValue, value: redirectURI))
                }
                
                if let clientIdentifier = self.clientIdentifier {
                    
                    queryItems.append(URLQueryItem(name: Parameter.client_id.rawValue, value: clientIdentifier))
                }
                
                urlComponents.queryItems = queryItems
                
                guard let url = urlComponents.url
                    else { fatalError("Invalid URL components: \(urlComponents)") }
                
                return HTTP.Request(url: url, headers: ["Content-Type": "application/x-www-form-urlencoded"])
            }
        }
        
        /*
        public struct Response: AccessTokenResponse {
            
            
        }*/
    }
}
