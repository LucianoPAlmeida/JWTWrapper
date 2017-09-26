//
//  JWTTests.swift
//  JWTTests
//
//  Created by Luciano Almeida on 26/09/17.
//

import XCTest
@testable import JWT

class JWTTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test() {
        let jwt = Token(string: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJNZSIsImlhdCI6MTUwNjI4Nzg3MCwiZXhwIjoxNTA2Mzc0MjcwLCJhdWQiOiJ3d3cuZXhhbXBsZS5jb20iLCJzdWIiOiJleGVtcGxlIiwiZmlyc3RfbmFtZSI6IkpvaG4iLCJsYXN0X25hbWUiOiJEb2UiLCJlbWFpbCI6ImRvZUBleGFtcGxlLmNvbSIsImlkIjoiMTIiLCJoZWlnaHQiOiIxLjc1In0.GShq6rUJcs50cMPap8hXb1oD9B-YpBi_e4s5OtNR_iY")
        
        //Test Headers
        XCTAssertEqual(jwt.algorithm, "HS256")
        XCTAssertNil(jwt.contentType)
        XCTAssertEqual(jwt.type, "JWT")
        
        //Test Claims
        XCTAssertEqual(jwt.issuer, "Me")
        XCTAssertEqual(jwt.audience, "www.example.com")
        XCTAssertEqual(jwt.subject, "exemple")
        XCTAssertEqual(jwt.issuedAt?.ISOString, "2017-09-24")
        XCTAssertEqual(jwt.expirationDate?.ISOString, "2017-09-25")
        XCTAssertFalse(jwt.isExpired)
        
        //Payload
        XCTAssertEqual(jwt.payload["first_name"] as? String, "John")
        XCTAssertEqual(jwt.payload.string(for: "last_name"), "Doe")
        XCTAssertEqual(jwt.payload.string(for: "email"), "doe@example.com")
        XCTAssertEqual(jwt.payload.int(for: "id"), 12)
        XCTAssertEqual(jwt.payload.float(for: "height"), 1.75)

    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

extension Date {
    var ISOString: String {
        get {
            let dtFmt = DateFormatter()
            let locale = Locale.current
            
            dtFmt.dateFormat = "yyyy-MM-dd"
            dtFmt.locale = locale
            
            return dtFmt.string(from: self)
        }
    }
}
