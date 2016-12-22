//
//  ImplicitGrant.swift
//  OAuth2
//
//  Created by Alsey Coleman Miller on 12/16/16.
//  Copyright © 2016 OpenStack. All rights reserved.
//

import SwiftFoundation

/// [4.2.  Implicit Grant](https://tools.ietf.org/html/rfc6749#section-4.2)
/// 
/// The implicit grant type is used to obtain access tokens (it does not
/// support the issuance of refresh tokens) and is optimized for public
/// clients known to operate a particular redirection URI.  These clients
/// are typically implemented in a browser using a scripting language
/// such as JavaScript.
///
/// Since this is a redirection-based flow, the client must be capable of
/// interacting with the resource owner's user-agent (typically a web
/// browser) and capable of receiving incoming requests (via redirection)
/// from the authorization server.
///
/// Unlike the authorization code grant type, in which the client makes
/// separate requests for authorization and for an access token, the
/// client receives the access token as the result of the authorization
/// request.
///
/// The implicit grant type does not include client authentication, and
/// relies on the presence of the resource owner and the registration of
/// the redirection URI.  Because the access token is encoded into the
/// redirection URI, it may be exposed to the resource owner and other
/// applications residing on the same device.
public struct ImplicitGrant {
    
    /// [4.2.1.  Authorization Request](https://tools.ietf.org/html/rfc6749#section-4.2.1)
    public typealias Request = AuthorizationRequest
    
    /// [4.2.2.  Access Token Response](https://tools.ietf.org/html/rfc6749#section-4.2.2)
    ///
    /// The authorization server MUST NOT issue a refresh token.
    ///
    /// For example, the authorization server redirects the user-agent by
    /// sending the following HTTP response:
    ///
    /// ```
    /// HTTP/1.1 302 Found
    /// Location: http://example.com/cb#access_token=2YotnFZFEjr1zCsicMWpAA&state=xyz&token_type=example&expires_in=3600
    /// ```
    public struct Response: AccessTokenResponse, JSONDecodable {
        
        public enum Parameter: String {
            
            case scope, state
        }
        
        public let accessToken: String
        
        public let tokenType: String
        
        public let expires: TimeInterval?
        
        public let scope: String?
        
        public let state: String?
        
        public init?(urlResponse: HTTP.Response) {
            
            guard urlResponse.statusCode == HTTP.StatusCode.Found.rawValue,
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
            
            self.scope = JSONObject[Parameter.scope.rawValue]?.stringValue
            self.state = JSONObject[Parameter.state.rawValue]?.stringValue
        }
    }
}
