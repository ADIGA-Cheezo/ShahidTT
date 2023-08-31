//
//  ShahidTTTests.swift
//  ShahidTTTests
//
//  Created by atsmac on 28/08/2023.
//

import XCTest
@testable import ShahidTT

final class ShahidTTTests: XCTestCase {
    
    func testSuccessfulLogin() {
            let viewModel = loginViewModel()
            viewModel.username = "sghotouk@gmail.com"
            viewModel.password = "password"
            
            let expectation = XCTestExpectation(description: "Login completion")
            
            viewModel.login { success in
                XCTAssertTrue(success, "Login should be successful")
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5.0)
        }
        
        func testFailedLogin() {
            let viewModel = loginViewModel()
            viewModel.username = "invalid@gmail.com"
            viewModel.password = "wrongpassword"
            
            let expectation = XCTestExpectation(description: "Login completion")
            
            viewModel.login { success in
                XCTAssertFalse(success, "Login should fail")
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5.0)
        }
    
    func testFetchDataPerformance() {
            let viewModel = HomeViewModel()
            measure {
                let expectation = XCTestExpectation(description: "Fetch data completion")
                viewModel.fetchData {
                    expectation.fulfill()
                }
                wait(for: [expectation], timeout: 10.0)
            }
        }
}
