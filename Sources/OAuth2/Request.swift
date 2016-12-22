//
//  Request.swift
//  OAuth2
//
//  Created by Alsey Coleman Miller on 12/16/16.
//  Copyright © 2016 OpenStack. All rights reserved.
//

import SwiftFoundation

public protocol Request {
    
    func toURLRequest() -> HTTP.Request
}
