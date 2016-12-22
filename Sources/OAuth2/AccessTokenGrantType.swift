//
//  AccessTokenGrantType.swift
//  OAuth2
//
//  Created by Alsey Coleman Miller on 12/16/16.
//  Copyright © 2016 OpenStack. All rights reserved.
//

/// Access Token Grant Type
public enum AccessTokenGrantType: String {
    
    /// Resource Owner Password Credentials Grant
    case password
    
    /// Client Credentials Grant
    case clientCredentials = "client_credentials"
    
    /// Authorization Code Token
    case authorizationCode = "authorization_code"
}
