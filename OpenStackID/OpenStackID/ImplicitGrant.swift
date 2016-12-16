//
//  ImplicitGrant.swift
//  OpenStackID
//
//  Created by Alsey Coleman Miller on 12/16/16.
//  Copyright © 2016 OpenStack. All rights reserved.
//

import Foundation

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
    
    
}
