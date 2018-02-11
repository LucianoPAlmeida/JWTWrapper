//
//  JWTTests.swift
//  JWTTests
//
//  Created by Luciano Almeida on 26/09/17.
//

import XCTest
@testable import JWTWrapper

class JWTTests: XCTestCase {

    func test() {
        let jwt = JWT(string: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJNZSIsImlhdCI6MTUwNjI4Nzg3MCwiZXhwIjoxNTA2Mzc0MjcwLCJhdWQiOiJ3d3cuZXhhbXBsZS5jb20iLCJzdWIiOiJleGVtcGxlIiwianRpIjoiand0aWQxMCIsIm5iZiI6MTUwNjM3NDI3MCwiZmlyc3RfbmFtZSI6IkpvaG4iLCJsYXN0X25hbWUiOiJEb2UiLCJlbWFpbCI6ImRvZUBleGFtcGxlLmNvbSIsImlkIjoxMiwiaGVpZ2h0IjoxLjc1LCJudW1iZXIiOjc4OX0.sJVuJ39lIouTnTEYlE_0ZlXVp8GXCy9Z7djQwZUDwLI")
        
        //Test Headers
        XCTAssertEqual(jwt.algorithm, "HS256")
        XCTAssertNil(jwt.contentType)
        XCTAssertEqual(jwt.type, "JWT")
        
        //Test Claims
        XCTAssertEqual(jwt.issuer, "Me")
        XCTAssertEqual(jwt.audience, "www.example.com")
        XCTAssertEqual(jwt.subject, "exemple")
        XCTAssertEqual(jwt.issuedAt?.fomatted, "2017-09-24")
        XCTAssertEqual(jwt.expirationDate?.fomatted, "2017-09-25")
        XCTAssertEqual(jwt.id, "jwtid10" )
        XCTAssertEqual(jwt.notBefore?.fomatted, "2017-09-25")
        XCTAssertFalse(jwt.isExpired)
        
        //Payload
        XCTAssertEqual(jwt.payload["first_name"] as? String, "John")
        XCTAssertEqual(jwt.payload.string(for: "last_name"), "Doe")
        XCTAssertEqual(jwt.payload.string(for: "email"), "doe@example.com")
        XCTAssertEqual(jwt.payload.int(for: "id"), 12)
        XCTAssertEqual(jwt.payload.double(for: "height"), 1.75)
        XCTAssertEqual(jwt.payload.float(for: "height"), 1.75)
        XCTAssertEqual(jwt.payload.number(for: "number"), 789)
        
        print(jwt.debugDescription)
        print(jwt.description)
        print(jwt.payload.description)
        print(jwt.payload.debugDescription)
        
        // Equatable
        let other = JWT(string: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9.TJVA95OrM7E2cBab30RMHrHDcEfxjoYZgeFONFh7HgQ")
        
        XCTAssertFalse(jwt == other)
        
    }
    
}

extension Date {
    var fomatted: String {
        let dtFmt = DateFormatter()
        let locale = Locale.current
            
        dtFmt.dateFormat = "yyyy-MM-dd"
        dtFmt.locale = locale
            
        return dtFmt.string(from: self)
    }
}
