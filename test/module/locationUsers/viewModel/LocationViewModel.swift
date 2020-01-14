//
//  LocationViewModel.swift
//  test
//
//  Created by PENA SANCHEZ Edwin Jose on 13/01/2020.
//  Copyright © 2020 safe365. All rights reserved.
//

import Foundation
import CoreLocation
import RxCoreLocation
import RxSwift
import RxCocoa

class LocationViewModel {
    let items: PublishSubject<[UserDTO]> = PublishSubject()
    let loading: PublishSubject<Bool> = PublishSubject()
    let error: PublishSubject<String> = PublishSubject()
    let location: PublishSubject<CLLocation> = PublishSubject()
    private let provider: HTTPProviderImp
    private let disposeBag = DisposeBag()
    private let locationManager = CLLocationManager()
    
    public init(provider: HTTPProviderImp) {
        self.provider = provider
    }
    
    required convenience init() {
        self.init(provider: HTTPProviderImp())
    }
    
    func configureLocationManager() {
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.locationManager.rx.didChangeAuthorization.subscribe(onNext: {[weak self] _, status in
            guard let strongSelf = self else {
                return
            }
            switch status {
            case .denied, .notDetermined, .restricted:
                strongSelf.error.onNext("You should allow and activate geolocation")
            default:
                strongSelf.didUpdateLocation()
            }
        })
            .disposed(by: disposeBag)
    }
    
    private func didUpdateLocation() {
        let didUpdateLocation = locationManager.rx.didUpdateLocations.observeOn(MainScheduler.instance)
        didUpdateLocation.take(1).subscribe(onNext: { [weak self] location in
            guard let strongSelf = self else {
                return
            }
            let locationCoordinate = location.locations[0].coordinate
            strongSelf.getUsers(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        }).disposed(by: disposeBag)
    }
    
    func getUsers(latitude: Double, longitude: Double) {
        debugPrint("start CALL WS Users")
        self.loading.onNext(true)
        self.provider.request(UserService(latitude: latitude, longitude: longitude)) { (result) in
            self.loading.onNext(false)
            switch result {
            case .success(let response):
                do {
                    let userDTO = try response.map([UserDTO].self)
                    self.items.onNext(userDTO)
                } catch {
                    self.error.onNext("Error when mapping the json")
                }
            case .failure:
                self.error.onNext("Error with the WS Users")
                break
            }
        }
    }
}
