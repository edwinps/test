//
//  LocationViewModelTest.swift
//  testTests
//
//  Created by PENA SANCHEZ Edwin Jose on 15/01/2020.
//  Copyright © 2020 safe365. All rights reserved.
//

import XCTest

import Moya
import RxSwift
@testable import test
import XCTest

class LocationViewModelTest: XCTestCase {
    var viewModel: LocationViewModel!
    var hTTPProvider: HTTPProviderImp!
    
    override func setUp() {
        self.viewModel = LocationViewModel()
    }
    
    override func tearDown() {
        self.viewModel = nil
        self.hTTPProvider = nil
    }
    
    func setupEndpoint(_ status: Int, sampleData: Data? = nil) {
        let customEndpointClosure = { (target: MultiTarget) -> Endpoint in
            let sampleRespone: Data! = sampleData == nil ? target.sampleData : sampleData
            return Endpoint(url: URL(target: target).absoluteString,
                            sampleResponseClosure: { .networkResponse(status, sampleRespone) },
                            method: target.method,
                            task: target.task,
                            httpHeaderFields: target.headers)
        }
        self.hTTPProvider = HTTPProviderImp(endpointClosure: customEndpointClosure)
        self.viewModel = LocationViewModel(provider: self.hTTPProvider)
    }
    
    func testGetUserSuccess() {
        // Given
        let disposeBag = DisposeBag()
        self.setupEndpoint(200)
        let expectUsers = expectation(description: "items contains users")
        
        // When
        self.viewModel
            .items
            .subscribe(onNext: { dtos in
                XCTAssertFalse(dtos.isEmpty)
                expectUsers.fulfill()
            }).disposed(by: disposeBag)
        
        self.viewModel
            .error
            .subscribe(onNext: { _ in
                XCTFail("there should be no error")
                expectUsers.fulfill()
            }).disposed(by: disposeBag)
        
        self.viewModel.getUsers(latitude: 41.387154, longitude: 2.167180)
        
        // Then
        wait(for: [expectUsers], timeout: 2)
    }
    
    func testGetUserRespondIncorrectJson() {
        // Given
        let disposeBag = DisposeBag()
        self.setupEndpoint(200, sampleData: "".utf8Encoded)
        let expectUsers = expectation(description: "items doesn't contains users")
        
        // When
        self.viewModel
            .items
            .subscribe(onNext: { _ in
                XCTFail("there should be no items")
                expectUsers.fulfill()
            }).disposed(by: disposeBag)
        
        self.viewModel
            .error
            .subscribe(onNext: { error in
                XCTAssertEqual(RespondError.mappingError.rawValue, error)
                expectUsers.fulfill()
            }).disposed(by: disposeBag)
        
        self.viewModel.getUsers(latitude: 41.387154, longitude: 2.167180)
        
        // Then
        wait(for: [expectUsers], timeout: 2)
    }
    
    func testGetUserFailure() {
        // Given
        let disposeBag = DisposeBag()
        self.setupEndpoint(500)
        let expectUsers = expectation(description: "items doesn't contains users")
        
        // When
        self.viewModel
            .items
            .subscribe(onNext: { _ in
                XCTFail("there should be no items")
                expectUsers.fulfill()
            }).disposed(by: disposeBag)
        
        self.viewModel
            .error
            .subscribe(onNext: { error in
                XCTAssertEqual(RespondError.serviceError.rawValue, error)
                expectUsers.fulfill()
            }).disposed(by: disposeBag)
        
        self.viewModel.getUsers(latitude: 41.387154, longitude: 2.167180)
        
        // Then
        wait(for: [expectUsers], timeout: 2)
    }
}
