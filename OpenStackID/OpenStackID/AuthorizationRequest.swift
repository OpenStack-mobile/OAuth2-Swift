//
//  AuthorizationRequest.swift
//  OpenStackID
//
//  Created by Alsey Coleman Miller on 12/16/16.
//  Copyright © 2016 OpenStack. All rights reserved.
//

import Foundation

/// Generic Authorization Request
public struct AuthorizationRequest: Request {
    
    /// The client constructs the request URI by adding the following
    /// parameters to the query component of the authorization endpoint URI
    /// using the `"application/x-www-form-urlencoded"` format.
    public enum Parameter: String {
        
        /// REQUIRED.  Value MUST be set to "code" or "token".
        case response_type
        
        /// REQUIRED.  The client identifier as described in
        // [Section 2.2](https://tools.ietf.org/html/rfc6749#section-2.2).
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
    
    public var responseType: AuthorizationResponseType = .authorizationCode
    
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
