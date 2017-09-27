# JWTWrapper

[![license](https://img.shields.io/github/license/mashape/apistatus.svg)](https://opensource.org/licenses/MIT)
[![Travis](https://img.shields.io/travis/LucianoPAlmeida/JWTWrapper.svg)](https://travis-ci.org/LucianoPAlmeida/JWTWrapper)
[![Codecov](https://img.shields.io/codecov/c/github/LucianoPAlmeida/JWTWrapper.svg)](https://codecov.io/gh/LucianoPAlmeida/JWTWrapper)

This is a convenience library to wrapper the JWT in a structure and make more parser easier. 
This is **NOT** a JWT issuer or validator, is just a simple abstraction to parse token payload and info in your app.


# Instalation

## Carthage   
  ```
    github "LucianoPAlmeida/JWTWrapper" ~> 1.0
  ```
## CocoaPods

  ```
      pod 'JWTWrapper', '~> 1.0'
  ``` 
  
## Usage
 ```swift
        let jwt = JWT(string: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJNZSIsImlhdCI6MTUwNjI4Nzg3MCwiZXhwIjoxNTA2Mzc0MjcwLCJhdWQiOiJ3d3cuZXhhbXBsZS5jb20iLCJzdWIiOiJleGVtcGxlIiwianRpIjoiand0aWQxMCIsIm5iZiI6MTUwNjM3NDI3MCwiZmlyc3RfbmFtZSI6IkpvaG4iLCJsYXN0X25hbWUiOiJEb2UiLCJlbWFpbCI6ImRvZUBleGFtcGxlLmNvbSIsImlkIjoxMiwiaGVpZ2h0IjoxLjc1LCJudW1iZXIiOjc4OX0.sJVuJ39lIouTnTEYlE_0ZlXVp8GXCy9Z7djQwZUDwLI")
        
        // Headers
        jwt.algorithm // "HS256"
        jwt.type //"JWT"
        
        // Claims
        jwt.issuer //"Me"
        jwt.audience //"www.example.com")
        jwt.subject //"exemple"
        jwt.issuedAt //"2017-09-24"
        jwt.expirationDate //"2017-09-25"
        jwt.id //"jwtid10" 
        jwt.notBefore //"2017-09-25"
        jwt.isExpired //false or true in case its expired
        
        //Payload
        jwt.payload["first_name"] // "John"
        jwt.payload.string(for: "last_name") //"Doe"
        jwt.payload.string(for: "email") // "doe@example.com"
        jwt.payload.int(for: "id") // 12
        jwt.payload.double(for: "height") // 1.75
        jwt.payload.float(for: "height") // 1.75
        jwt.payload.number(for: "number") // 789
    
 ```
# Licence 

JWTWrapper is released under the [MIT License](https://opensource.org/licenses/MIT).
