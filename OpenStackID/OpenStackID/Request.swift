//
//  Request.swift
//  OpenStackID
//
//  Created by Alsey Coleman Miller on 12/16/16.
//  Copyright © 2016 OpenStack. All rights reserved.
//

import Foundation

public protocol Request {
    
    func toURLRequest() -> URLRequest
}
