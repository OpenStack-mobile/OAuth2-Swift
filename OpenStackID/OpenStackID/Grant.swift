//
//  Client.swift
//  OpenStackID
//
//  Created by Alsey Coleman Miller on 12/16/16.
//  Copyright © 2016 OpenStack. All rights reserved.
//

import Foundation

public enum GrantType: String {
    
    /// Resource Owner Password Credentials Grant Request.
    case password
    
    /// Client Credentials Grant Request
    case clientCredentials = "client_credentials"
}

public protocol GrantRequest: Request {
    
    /// The type of grant for this request.
    static var grant: GrantType { get }
    
    /// The scope of the authorization.
    var scope: String? { get }
}

public protocol GrantResponse: Response {
    
    var accessToken: String { get }
    
    var tokenType: String { get }
    
    var expiration: TimeInterval? { get }
}

public enum GrantRequestJSONKey: String {
    
    case grant_type, scope
}

public enum GrantResponseJSONKey: String {
    
    case access_token, token_type, expires_in, refresh_token
}

// MARK: - Owner Password Credentials Grant

public struct ResourceOwnerPasswordCredentialsGrantRequest: GrantRequest {
    
    enum JSONKey: String {
        
        case username, password
    }
    
    public static let grant: GrantType = .password
    
    public var scope: String?
    
    /// The username of the resource owner.
    public var username: String
    
    /// The password of the resource owner.
    public var password: String
}

public struct ResourceOwnerPasswordCredentialsGrantResponse: GrantResponse {
    
    public let accessToken: String
    
    public let tokenType: String
    
    public let refreshToken: String
    
    public let expiration: TimeInterval?
}

// MARK: - Client Credentials Grant

public struct ClientCredentialsGrantRequest: GrantRequest {
    
    public static let grant: GrantType = .clientCredentials
    
    public var scope: String?
}

public struct ClientCredentialsGrantResponse: GrantResponse {
    
    public let accessToken: String
    
    public let tokenType: String
    
    public let expiration: TimeInterval?
}





