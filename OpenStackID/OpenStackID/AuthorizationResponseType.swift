//
//  AuthorizationResponseType.swift
//  OpenStackID
//
//  Created by Alsey Coleman Miller on 12/16/16.
//  Copyright © 2016 OpenStack. All rights reserved.
//

/// Response type for Authorization Grant requests.
public enum AuthorizationResponseType: String {
    
    /// Expected response type for requesting an
    /// authorization code as described by 
    /// [Section 4.1.1](https://tools.ietf.org/html/rfc6749#section-4.1.1)
    case authorizationCode = "code"
    
    /// For requesting an access token (implicit grant) as described by
    /// [Section 4.2.1](https://tools.ietf.org/html/rfc6749#section-4.1.2)
    case implicit = "token"
}
