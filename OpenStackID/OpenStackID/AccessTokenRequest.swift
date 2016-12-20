//
//  AccessTokenRequest.swift
//  OpenStackID
//
//  Created by Alsey Coleman Miller on 12/19/16.
//  Copyright © 2016 OpenStack. All rights reserved.
//

import SwiftFoundation

public protocol AccessTokenRequest: Request {
    
    static var grantType: AccessTokenGrantType { get }
    
    var scope: String? { get }
}

public enum AccessTokenRequestParameter: String {
    
    /// REQUIRED.  Value MUST be set to "authorization_code".
    case grant_type
    
    /// REQUIRED.  The authorization code received from the authorization server.
    case code
}
