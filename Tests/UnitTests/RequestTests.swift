//
//  RequestTests.swift
//  OAuth2
//
//  Created by Alsey Coleman Miller on 12/22/16.
//  Copyright © 2016 OpenStack. All rights reserved.
//

#if os(Linux)
    import Glibc
#endif

import XCTest
import SwiftFoundation
@testable import OAuth2

final class RequestTests: XCTestCase {
    
    static let allTests: [(String, (RequestTests) -> () throws -> Void)] = [("testClientCredentials", testClientCredentials)]
    
    func testClientCredentials() {
        
        let client = HTTP.Client()
        
        let clientCredentialsRequest = ClientCredentialsGrant.Request(endpoint: TestData.tokenEndpoint, scope: TestData.scope, credentials: (clientIdentifier: TestData.clientID, clientSecret: TestData.clientSecret))
        
        do {
            
            let urlResponse = try client.send(request: clientCredentialsRequest.toURLRequest())
            
            guard let tokenResponse = ClientCredentialsGrant.Response(urlResponse: urlResponse)
                else { XCTFail("Could not parse response: \(urlResponse)"); return }
            
            print("Got access token:\n\(tokenResponse)")
        }
        
        catch { XCTFail("\(error)") }
    }
}

