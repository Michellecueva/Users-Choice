//
//  Comprehensive_AssessmentTests.swift
//  Comprehensive AssessmentTests
//
//  Created by Michelle Cueva on 12/2/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import XCTest
//@testable import Comprehensive_Assessment

class Comprehensive_AssessmentTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
      
    }
    
    private func TicketModel() -> Data? {
             let bundle = Bundle(for: type(of: self))
             guard let pathToData = bundle.path(forResource: "TicketmasterSample", ofType: ".json")  else {
                 XCTFail("couldn't find Json")
                 return nil
             }
             let url = URL(fileURLWithPath: pathToData)
             do {
                 let data = try Data(contentsOf: url)
                 return data
             } catch let error {
                 fatalError("couldn't find data \(error)")
             }
         }
    
    func testTicketModel () {
            let data = TicketModel() ?? Data()
            
            do {
                let ticketData = try TicketWrapper.decodeEventFromData(from: data)
                
                 XCTAssertTrue(ticketData.count > 0, "events not loaded")
            } catch let error {
                XCTFail(error.localizedDescription)
            }
    }
    
    private func MuseumModel() -> Data? {
               let bundle = Bundle(for: type(of: self))
               guard let pathToData = bundle.path(forResource: "MuseumSample", ofType: ".json")  else {
                   XCTFail("couldn't find Json")
                   return nil
               }
               let url = URL(fileURLWithPath: pathToData)
               do {
                   let data = try Data(contentsOf: url)
                   return data
               } catch let error {
                   fatalError("couldn't find data \(error)")
               }
           }
    func testMuseumModel () {
            let data = MuseumModel() ?? Data()
            
            do {
                let museumData = try MuseumWrapper.decodeObjectFromData(from: data)
                
                 XCTAssertTrue(museumData.count > 0, "objects not loaded")
            } catch let error {
                XCTFail(error.localizedDescription)
            }
    }
    
    private func ArtObjectModel() -> Data? {
                  let bundle = Bundle(for: type(of: self))
                  guard let pathToData = bundle.path(forResource: "ArtObjectSample", ofType: ".json")  else {
                      XCTFail("couldn't find Json")
                      return nil
                  }
                  let url = URL(fileURLWithPath: pathToData)
                  do {
                      let data = try Data(contentsOf: url)
                      return data
                  } catch let error {
                      fatalError("couldn't find data \(error)")
                  }
              }
       func testArtObjectModel () {
               let data = ArtObjectModel() ?? Data()
               
               do {
                let objectData = try ArtObjectWrapper.decodeDetailsFromData(from: data)
                XCTAssert(type(of: objectData) == ArtObjectDetail.self , "You do not have an ArtObjectDetail")
                
               } catch let error {
                   XCTFail(error.localizedDescription)
               }
       }


}
