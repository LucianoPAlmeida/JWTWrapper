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
        
        public static var values: [Claims] { return [.iss , .sub, .aud, .exp, .nbf, .iat, .jit] }
    }
    
    public enum Header : String {
        case typ = "typ"
        case cty = "cty"
        case alg = "alg"
    }
    
    
    public struct Payload {
        private(set) var raw: [String : Any] = [:]
        
        init(dictionary: [String : Any]) {
            raw = dictionary
        }
        
        public subscript(key: String) -> Any? {
            return raw[key]
        }
        
        public func string(for key: String) -> String? {
            return raw[key] as? String
        }
        
        public func double(for key: String) -> Double? {
            return raw[key] as? Double
        }
        
        public func float(for key: String) -> Float? {
            return raw[key] as? Float
        }
        
    }
    
    private(set) var string: String = ""
    
    private(set) var header: [String : Any] = [:]
    
    
    private(set) var payload: Payload = Payload(dictionary: [:])
    
    private(set) var signature: String  = ""
    
    //Claims
    
    /**
         Property that represents "iss" (Issuer) Claim
         https://tools.ietf.org/html/rfc7519#section-4.1.1
     */
    public private(set) var issuer: String?
    
    /**
         Property that represents "sub" (Subject) Claim
         https://tools.ietf.org/html/rfc7519#section-4.1.2
     */
    public private(set) var subject: String?
    
    /**
         Property that represents "aud" (Audience) Claim
         https://tools.ietf.org/html/rfc7519#section-4.1.3
     */
    public private(set) var audience: String?
    
    /**
         Property that represents "exp" (Expiration Time) Claim
         https://tools.ietf.org/html/rfc7519#section-4.1.4
     */
    public private(set) var expirationDate: Date?
    
    /**
         Property that represents "nbf" (Not Before) Claim
         https://tools.ietf.org/html/rfc7519#section-4.1.5
     */
    public private(set) var notBefore: Date?
    
    /**
         Property that represents "iat" (Issued At) Claim
         https://tools.ietf.org/html/rfc7519#section-4.1.6
     */
    public private(set) var issuedAt: Date?
    
    /**
         Property that represents "jti" (JWT ID) Claim
         https://tools.ietf.org/html/rfc7519#section-4.1.7
     */
    public private(set) var id: String?
    
    
    // Headers

    /**
         Property that represents "alg" of the header
     */
    public private(set) var algorithm: String?
    
    /**
         Property that represents "typ" (Type) Header Parameter
         https://tools.ietf.org/html/rfc7519#section-5.1
     */
    public private(set) var type: String?
    
    /**
         Property that represents "cty" (Content Type) Header Parameter
         https://tools.ietf.org/html/rfc7519#section-5.2
     */
    public private(set) var contentType: String?
    
    
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
            
            parseHeaders(header: header)
            
            var parsed = dictionary(from: parts[1])
            parseClaims(payload: parsed)
            parsed.removeAll(keys: Claims.values.map({ $0.rawValue } ))

            payload = Payload(dictionary: parsed)
            
            if parts.count > 2 {
                signature = parts[2]
            }
        }
    }
    
    private mutating func parseClaims(payload: [ String: Any ]) {
        
        issuer = payload[Claims.iss.rawValue] as? String
        subject = payload[Claims.sub.rawValue] as? String
        audience = payload[Claims.aud.rawValue] as? String
        id = payload[Claims.jit.rawValue] as? String

        if let exp = payload[Claims.exp.rawValue] as? TimeInterval {
            expirationDate = Date(timeIntervalSince1970: exp)
        }
        
        if let iat = payload[Claims.iat.rawValue] as? TimeInterval {
            issuedAt = Date(timeIntervalSince1970: iat)
        }
        
        if let nbf = payload[Claims.iat.rawValue] as? TimeInterval {
            notBefore = Date(timeIntervalSince1970: nbf)
        }

    }
    
    private mutating func parseHeaders(header: [String : Any]) {
        algorithm = header[Header.alg.rawValue] as? String
        type = header[Header.typ.rawValue] as? String
        contentType = header[Header.cty.rawValue] as? String
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

extension Dictionary {
    public mutating func removeAll(keys: [Key]) {
        keys.forEach({ removeValue(forKey: $0)})
    }
}
