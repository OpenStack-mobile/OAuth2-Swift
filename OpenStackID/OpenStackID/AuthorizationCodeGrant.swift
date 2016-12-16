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
    }
}
