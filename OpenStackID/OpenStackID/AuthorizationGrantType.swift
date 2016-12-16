//
//  AuthorizationGrantType.swift
//  OpenStackID
//
//  Created by Alsey Coleman Miller on 12/16/16.
//  Copyright © 2016 OpenStack. All rights reserved.
//

/// The authorization grant is given to a client application by the resource owner, 
/// in cooperation with the authorization server associated with the resource server.
public enum AuthorizationGrantType: String {
    
    /// An authorization grant using an authorization code works like this (the numbers correspond to the steps shown in the diagram below the description):
    ///
    /// 1) The resource owner (user) accesses the client application.
    ///
    /// 2) The client application tells the user to login to the client application via an authorization server (e.g. Facebook, Twitter, Google etc.).
    ///
    /// 3) To login via the authorizaion server, the user is redirected to the authorization server by the client application. The client application sends its client ID along to the authorization server, so the authorization server knows which application is trying to access the protected resources.
    ///
    /// 4) The user logs in via the authorization server. After successful login the user is asked if she wants to grant access to her resources to the client application. If the user accepts, the user is redirected back to the client application.
    ///
    /// 5) When redirected back to the client application, the authorization server sends the user to a specific redirect URI, which the client application has registered with the authorization server ahead of time. Along with the redirection, the authorization server sends an authorization code, representing the authorization.
    ///
    /// 6) When the redirect URI in the client application is accessed, the client application connects directly to the authorization server. The client application sends the authorization code along with its own client ID and and client secret.
    ///
    /// 7) If the authorization server can accept these values, the authorization server sends back an access token.
    ///
    /// 10) The client application can now use the access token to request resources from the resource server. The access token serves as both authentication of the client, resource owner (user) and authorization to access the resources.
    ///
    case authorizationCode
    
    /// An implicit authorization grant is similar to an authorization code grant, except the access token is returned to the client application already after the user has finished the authorization. The access token is thus returned when the user agent is redirected to the redirect URI.
    ///
    /// This of course means that the access token is accessible in the user agent, or native application participating in the implicit authorization grant. The access token is not stored securely on a web server.
    ///
    /// Furthermore, the client application can only send its client ID to the authorization server. If the client were to send its client secret too, the client secret would have to be stored in the user agent or native application too. That would make it vulnerable to hacking.
    ///
    /// Implicit authorization grant is mostly used in a user agent or native client application. The user agent or native application would receive the access token from the authorization server.
    case implicit = "token"
    
    /// The resource owner password credentials authorization grant method works by giving the client application access to the resource owners credentials. For instance, a user could type his Twitter user name and password (credentials) into the client application. The client application could then use the user name and password to access resources in Twitter.
    ///
    /// Using the resource owner password credentials requires a lot of trust in the client application. You do not want to type your credentials into an application you suspect might abuse it.
    ///
    /// The resource owner password credentials would normally be used by user agent client applications, or native client applications.
    case resourceOwnerPasswordCredentials
    
    /// Client credential authorization is for the situations where the client application needs to access resources or call functions in the resource server, which are not related to a specific resource owner (e.g. user). 
    ///
    /// For instance, obtaining a list of venues from Foursquare. This does not necessary have anything to do with a specific Foursquare user.
    case clientCredentials
}
