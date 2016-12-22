//
//  Response.swift
//  OAuth2
//
//  Created by Alsey Coleman Miller on 12/16/16.
//  Copyright © 2016 OpenStack. All rights reserved.
//

import SwiftFoundation

public protocol Response {
    
    init?(urlResponse: HTTP.Response)
}
