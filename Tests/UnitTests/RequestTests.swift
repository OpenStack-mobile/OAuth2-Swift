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
        
        let clientCredentialsRequest = ClientCredentialsGrant.Request(endpoint: TestData.tokenEndpoint, scope: TestData.scope, clientCredentials: (identifier: TestData.clientID, secret: TestData.clientSecret))
        
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
        
        let clientCredentialsRequest = ClientCredentialsGrant.Request(endpoint: TestData.tokenEndpoint, scope: TestData.scope, clientCredentials: nil)
        
        do {
            
            let urlResponse = try client.send(request: clientCredentialsRequest.toURLRequest())
            
            guard let response = ClientCredentialsGrant.Response.Error(urlResponse: urlResponse)
                else { XCTFail("Could not parse response: \(urlResponse)"); return }
            
            print("Got error:\n\(response)")
        }
            
        catch { XCTFail("\(error)") }
    }
    
    /*
    func testResourceOwnerPasswordCredentialsGrant() {
        
        let client = HTTP.Client()
        
        let request = ResourceOwnerPasswordCredentialsGrant.Request(endpoint: TestData.tokenEndpoint, scope: TestData.scope, username: TestData.username, password: TestData.password, clientCredentials: (identifier: TestData.clientID, secret: TestData.clientSecret))
        
        do {
            
            let urlResponse = try client.send(request: request.toURLRequest())
            
            guard let response = ResourceOwnerPasswordCredentialsGrant.Response.Success(urlResponse: urlResponse)
                else { XCTFail("Could not parse response: \(urlResponse)"); return }
            
            print("Got access token:\n\(response)")
        }
            
        catch { XCTFail("\(error)") }
    }
    
    func testResourceOwnerPasswordCredentialsGrantError() {
        
        let client = HTTP.Client()
        
        let request = ResourceOwnerPasswordCredentialsGrant.Request(endpoint: TestData.tokenEndpoint, scope: TestData.scope, username: "", password: "", clientCredentials: nil)
        
        do {
            
            let urlResponse = try client.send(request: request.toURLRequest())
            
            guard let response = ResourceOwnerPasswordCredentialsGrant.Response.Error(urlResponse: urlResponse)
                else { XCTFail("Could not parse response: \(urlResponse)"); return }
            
            print("Got error:\n\(response)")
        }
            
        catch { XCTFail("\(error)") }
    }
     */
    
    
}

