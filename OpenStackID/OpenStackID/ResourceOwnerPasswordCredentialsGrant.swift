//
//  ResourceOwnerPasswordCredentialsGrant.swift
//  OpenStackID
//
//  Created by Alsey Coleman Miller on 12/16/16.
//  Copyright © 2016 OpenStack. All rights reserved.
//

import SwiftFoundation

public struct ResourceOwnerPasswordCredentialsGrant {
    
    public struct Request: AccessTokenRequest {
        
        public enum Parameter: String {
            
            case grant_type, scope, username, password
        }
        
        public static let grantType: AccessTokenGrantType = .password
        
        /// The URL of the OAuth2 endpoint for access token grants.
        public var endpoint: String
        
        public var scope: String?
        
        public var username: String
        
        public var password: String
        
        public func toURLRequest() -> HTTP.Request {
            
            
        }
    }
}
