//
//  ResourceOwnerPasswordCredentialsGrant.swift
//  OAuth2
//
//  Created by Alsey Coleman Miller on 12/16/16.
//  Copyright © 2016 OpenStack. All rights reserved.
//

import SwiftFoundation

/// Resource Owner Password Credentials Grant OAuth2 flow
public struct ResourceOwnerPasswordCredentialsGrant {
    
    public struct Request: AccessTokenRequest {
        
        public enum Parameter: String {
            
            case grant_type, scope, client_id, client_secret, username, password
        }
        
        public static let grantType: AccessTokenGrantType = .password
        
        /// The URL of the OAuth2 endpoint for access token grants.
        public var endpoint: URL
        
        public var scope: String?
        
        public var username: String
        
        public var password: String
        
        public var clientCredentials: (identifier: String, secret: String)?
        
        public func toURLRequest() -> HTTP.Request {
            
            var parameters = [Parameter: String]()
            
            parameters[.grant_type] = type(of: self).grantType.rawValue
            
            parameters[.scope] = scope
            
            parameters[.username] = username
            
            parameters[.password] = password
            
            if let (clientID, clientSecret) = clientCredentials {
                
                parameters[.client_id] = clientID
                
                parameters[.client_secret] = clientSecret
            }
            
            // crashes compiler
            //let stringParameters = parameters.reduce([String: String](), { $0.0[$0.1.key.rawValue] = $0.1.value })
            
            var stringParameters = [String: String](minimumCapacity: parameters.count)
            parameters.forEach { stringParameters[$0.0.rawValue] = $0.value }
            
            let formURLEncoded = FormURLEncoded(parameters: stringParameters)
            
            return HTTP.Request(url: endpoint,
                                body: formURLEncoded.toData(),
                                headers: ["Content-Type": "application/x-www-form-urlencoded"],
                                method: .POST)
        }
    }
    
    public struct Response {
        
        public struct Success: RefreshableAccessTokenResponse, JSONDecodable {
            
            public static let grantType: AccessTokenGrantType = .clientCredentials
            
            public let accessToken: String
            
            public let tokenType: String
            
            public let expires: TimeInterval?
            
            public let refreshToken: String?
            
            public init?(urlResponse: HTTP.Response) {
                
                guard urlResponse.statusCode == HTTP.StatusCode.OK.rawValue,
                    let jsonString = String(UTF8Data: urlResponse.body),
                    let json = JSON.Value(string: jsonString)
                    else { return nil }
                
                self.init(JSONValue: json)
            }
            
            public init?(JSONValue: JSON.Value) {
                
                guard let JSONObject = JSONValue.objectValue,
                    let accessToken = JSONObject[AccessTokenResponseParameter.access_token.rawValue]?.stringValue,
                    let tokenType = JSONObject[AccessTokenResponseParameter.token_type.rawValue]?.stringValue
                    else { return nil }
                
                self.accessToken = accessToken
                self.tokenType = tokenType
                
                if let expires = JSONObject[AccessTokenResponseParameter.expires_in.rawValue]?.integerValue {
                    
                    self.expires = TimeInterval(expires)
                    
                } else {
                    
                    self.expires = nil
                }
                
                self.refreshToken = JSONObject[AccessTokenResponseParameter.refresh_token.rawValue]?.stringValue
            }
        }
        
        /// Resource Owner Password Credentials Grant Error Response
        public struct Error: AccessTokenErrorResponseJSON {
            
            public let code: AccessTokenErrorCode
            
            public let errorDescription: String?
            
            public let errorURI: String?
            
            public init(code: AccessTokenErrorCode, errorDescription: String? = nil, errorURI: String? = nil) {
                
                self.code = code
                self.errorDescription = errorDescription
                self.errorURI = errorURI
            }
        }
    }
}
