//
//  MapViewController.swift
//  test
//
//  Created by PENA SANCHEZ Edwin Jose on 15/01/2020.
//  Copyright © 2020 safe365. All rights reserved.
//

import Kingfisher
import MapKit
import RxCocoa
import RxSwift
import SVProgressHUD
import UIKit

class MapViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!
    
    var items = PublishSubject<[UserDTO]>()
    let disposeBag = DisposeBag()
    var viewModel: LocationViewModel
    private let locationManager = CLLocationManager()
    var router: LocationRouterImp?
    
    public init(viewModel: LocationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder decoder: NSCoder) {
        self.viewModel = LocationViewModel()
        super.init(coder: decoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.router = LocationRouterImp(viewController: self)
        self.setupBinding()
        self.viewModel.configureLocationManager()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
        self.configureMap()
    }
    
    private func setupBinding() {
        // binding loading to vc
        self.viewModel.loading
            .bind(to: SVProgressHUD.rx.isAnimating).disposed(by: self.disposeBag)
        
        // binding items to items viewmodel
        self.viewModel
            .items
            .observeOn(MainScheduler.instance)
            .bind(to: self.items)
            .disposed(by: self.disposeBag)
        
        // observing errors to show
        self.viewModel
            .error
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { error in
                SVProgressHUD.showError(withStatus: error)
            })
            .disposed(by: self.disposeBag)
    }
    
    func configureMap() {
        // Remove any existing Annotation from the map, and add the new users
        self.viewModel.items
            .subscribe(onNext: { [weak self] users in
                guard let `self` = self else { return }
                self.mapView.removeAnnotations(self.mapView.annotations.filter { $0 is CustomPointAnnotation })
                for user in users {
                    if let latitude = user.latitude, let longitude = user.longitude {
                        let customPoint = CustomPointAnnotation(user: user,
                                                                coordinate: CLLocationCoordinate2DMake(latitude, longitude))
                        self.mapView.addAnnotation(customPoint)
                    }
                }
            }).disposed(by: self.disposeBag)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let customAnnotation = annotation as? CustomPointAnnotation else { return nil }
        
        let annotationIdentifier = "customannotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
        }
        else {
            annotationView?.annotation = annotation
        }
        if let avatar = customAnnotation.user.avatar, let url = URL(string: avatar) {
            let imageView = UIImageView()
            imageView.kf.setImage(with: url) { result in
                switch result {
                case .success(let value):
                    let size = CGSize(width: 25, height: 25)
                    annotationView?.image = value.image.resized(to: size)
                case .failure:
                    break
                }
            }
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        // Adjust the map to show all the annotations (user location and any destination annotation)
        mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let customAnnotation = view.annotation as? CustomPointAnnotation else { return }
        self.router?.navigate(to: .detailLocation(user: customAnnotation.user))
    }
}
