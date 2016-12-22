//
//  AccessTokenRequest.swift
//  OAuth2
//
//  Created by Alsey Coleman Miller on 12/19/16.
//  Copyright © 2016 OpenStack. All rights reserved.
//

import SwiftFoundation

public protocol AccessTokenRequest: Request {
    
    static var grantType: AccessTokenGrantType { get }
}
