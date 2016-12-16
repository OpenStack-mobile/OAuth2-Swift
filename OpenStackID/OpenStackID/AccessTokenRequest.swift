//
//  AccessTokenRequest.swift
//  OpenStackID
//
//  Created by Alsey Coleman Miller on 12/16/16.
//  Copyright © 2016 OpenStack. All rights reserved.
//

import Foundation

public struct AccessTokenRequest {
    
    
}

public enum AccessTokenGrantType: String {
    
    /// Resource Owner Password Credentials Grant
    case password
    
    /// Client Credentials Grant
    case clientCredentials = "client_credentials"
    
    /// Authorization Code Token
    case authorizationCode = "authorization_code"
}
