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
    
    static let allTests: [(String, (RequestTests) -> () throws -> Void)] = [
        ("testClientCredentials", testClientCredentials),
        ("testClientCredentialsError", testClientCredentialsError),
    ]
    
    func testClientCredentials() {
        
        let client = HTTP.Client()
        
        let clientCredentialsRequest = ClientCredentialsGrant.Request(endpoint: TestData.tokenEndpoint, scope: TestData.scope, credentials: (clientIdentifier: TestData.clientID, clientSecret: TestData.clientSecret))
        
        do {
            
            let urlResponse = try client.send(request: clientCredentialsRequest.toURLRequest())
            
            guard let response = ClientCredentialsGrant.Response.Success(urlResponse: urlResponse)
                else { XCTFail("Could not parse response: \(urlResponse)"); return }
            
            print("Got access token:\n\(response)")
        }
        
        catch { XCTFail("\(error)") }
    }
    
    func testClientCredentialsError() {
        
        let client = HTTP.Client()
        
        let clientCredentialsRequest = ClientCredentialsGrant.Request(endpoint: TestData.tokenEndpoint, scope: TestData.scope, credentials: nil)
        
        do {
            
            let urlResponse = try client.send(request: clientCredentialsRequest.toURLRequest())
            
            guard let response = ClientCredentialsGrant.Response.Error(urlResponse: urlResponse)
                else { XCTFail("Could not parse response: \(urlResponse)"); return }
            
            print("Got error:\n\(response)")
        }
            
        catch { XCTFail("\(error)") }
    }
}

