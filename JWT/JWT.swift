//
//  JWT.swift
//  JWT
//
//  Created by Luciano Almeida on 26/09/17.
//

import Foundation



public struct JWT : CustomStringConvertible, CustomDebugStringConvertible {
    
    // https://tools.ietf.org/html/rfc7519#section-4.1
    public enum Claims : String {
        case iss = "iss"
        case sub = "sub"
        case aud = "aud"
        case exp = "exp"
        case nbf = "nbf"
        case iat = "iat"
        case jit = "jti"
    }
    
    private(set) var string: String = "" {
        didSet{
            decode(token: string)
        }
    }
    
    private(set) var header: [String : Any] = [:]
    
    
    private(set) var payload: [String : Any] = [:]
    
    private(set) var signature: String  = ""
    
    //Claims
    
    /**
         Property that represents "iss" (Issuer) Claim
     
     */
    private(set) var issuer: String?
    
    /**
     Property that represents "sub" (Subject) Claim
     
     */
    private(set) var subject: String?
    
    /**
         Property that represents "aud" (Audience) Claim
     */
    private(set) var audience: String?
    
    /**
         Property that represents "exp" (Expiration Time) Claim
     */
    private(set) var expirationDate: Date?
    
    /**
         Property that represents "nbf" (Not Before) Claim
     */
    private(set) var notBefore: Date?
    
    /**
         Property that represents "iat" (Issued At) Claim
     */
    private(set) var issuedAt: Date?
    
    /**
         Property that represents "jti" (JWT ID) Claim
     */
    private(set) var id: String?
    
    //Computed properties
    var isExpired: Bool {
        if let expDate = expirationDate {
            return expDate < Date()
        }
        return false
    }
    
    init(string: String) {
        self.string = string
        decode(token: string)
    }
    
    private mutating func decode(token : String) {
        let parts = token.components(separatedBy: ".")
        if parts.count >= 2 {
            header = dictionary(from: parts[0])
            payload = dictionary(from: parts[1])
            
            if parts.count > 2 {
                signature = parts[2]
            }
        }
    }
    
    private mutating func parseClaims(payload: [ String: Any ]) {
        if let exp = payload["iat"] as? TimeInterval {
            issuedAt = Date(timeIntervalSince1970: exp)
        }
        
        if let exp = payload["exp"] as? TimeInterval {
            expirationDate = Date(timeIntervalSince1970: exp)
        }
        
    }
    
    private func dictionary(from string: String?) -> [String : Any] {
        if let unwrappedString = string,  let data = base64decode(unwrappedString) {
            if let dic = try? JSONSerialization.jsonObject(with: data,
                                                           options: JSONSerialization.ReadingOptions.allowFragments) {
                return dic as? [String : Any] ?? [:]
            }
        }
        return [:]
    }
    
    public var description: String {
        return "[header = \(header)\npayload = \(payload), signature = \(signature), exp = \(String(describing: expirationDate)), iat = \(String(describing: issuedAt))]"
    }
    
    public var debugDescription: String {
        return "[header = \(header)\npayload = \(payload), signature = \(signature), exp = \(String(describing: expirationDate)), iat = \(String(describing: issuedAt))]"
    }
}

extension JWT {
    
    fileprivate func base64decode(_ input: String) -> Data? {
        let rem = input.characters.count % 4
        
        var ending = ""
        if rem > 0 {
            let amount = 4 - rem
            ending = String(repeating: "=", count: amount)
        }
        
        let base64 = input
            .replacingOccurrences(of: "-", with: "+", options: NSString.CompareOptions.caseInsensitive, range: nil)
            .replacingOccurrences(of: "_", with: "/", options: NSString.CompareOptions.caseInsensitive, range: nil) + ending
        
        return Data(base64Encoded: base64, options: NSData.Base64DecodingOptions(rawValue: 0))
    }
    
}
