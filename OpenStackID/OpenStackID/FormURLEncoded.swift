//
//  FormURLEncoded.swift
//  OpenStackID
//
//  Created by Alsey Coleman Miller on 12/21/16.
//  Copyright © 2016 OpenStack. All rights reserved.
//

import SwiftFoundation

/// Form URL Encoded data for sending in an HTTP body.
public struct FormURLEncoded {
    
    // MARK: - Properties
    
    public var parameters: [String: String]
    
    // MARK: - Initialization
    
    public init(parameters: [String: String]) {
        
        self.parameters = parameters
    }
}

// MARK: - Equatable

extension FormURLEncoded: Equatable {
    
    public static func == (lhs: FormURLEncoded, rhs: FormURLEncoded) -> Bool {
        
        return lhs.parameters == rhs.parameters
    }
}

// MARK: - DataConvertible

extension FormURLEncoded: DataConvertible {
    
    public init?(data: Data) {
        
        guard let string = String(UTF8Data: data)
            else { return nil }
        
        let components = string.components(separatedBy: "&")
        
        var parameters = [String: String](minimumCapacity: components.count)
        
        for component in components {
            
            let subcomponents = component.components(separatedBy: "=")
            
            guard subcomponents.count == 2,
                let parameter = subcomponents[0].removingPercentEncoding,
                let value = subcomponents[1].removingPercentEncoding
                else { return nil }
            
            parameters[parameter] = value
        }
        
        self.parameters = parameters
    }
    
    public func toData() -> Data {
        
        return parameters.map({ "\($0)=\(FormURLEncoded.escape($1))" }).joined(separator: "&").toUTF8Data()
    }
}

// MARK: - Utility Functions

public extension FormURLEncoded {
    
    // https://github.com/Alamofire/Alamofire/blob/master/Source/ParameterEncoding.swift
    /// Returns a percent-escaped string following RFC 3986 for a query string key or value.
    ///
    /// RFC 3986 states that the following characters are "reserved" characters.
    ///
    /// - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
    /// - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
    ///
    /// In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
    /// query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
    /// should be percent-escaped in the query string.
    ///
    /// - parameter string: The string to be percent-escaped.
    ///
    /// - returns: The percent-escaped string.
    ///
    public static func escape(_ string: String) -> String {
        
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        var escaped = ""
        
        //==========================================================================================================
        //
        //  Batching is required for escaping due to an internal bug in iOS 8.1 and 8.2. Encoding more than a few
        //  hundred Chinese characters causes various malloc error crashes. To avoid this issue until iOS 8 is no
        //  longer supported, batching MUST be used for encoding. This introduces roughly a 20% overhead. For more
        //  info, please refer to:
        //
        //      - https://github.com/Alamofire/Alamofire/issues/206
        //
        //==========================================================================================================
        if #available(iOS 8.3, *) {
            escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
        } else {
            let batchSize = 50
            var index = string.startIndex
            
            while index != string.endIndex {
                let startIndex = index
                let endIndex = string.index(index, offsetBy: batchSize, limitedBy: string.endIndex) ?? string.endIndex
                let range = startIndex..<endIndex
                
                let substring = string.substring(with: range)
                
                escaped += substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? substring
                
                index = endIndex
            }
        }
        
        return escaped
    }
}
