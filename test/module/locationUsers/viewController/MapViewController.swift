//
//  MapViewController.swift
//  test
//
//  Created by PENA SANCHEZ Edwin Jose on 15/01/2020.
//  Copyright © 2020 safe365. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa
import SVProgressHUD
import Kingfisher

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var items = PublishSubject<[UserDTO]>()
    let disposeBag = DisposeBag()
    var viewModel: LocationViewModel
    private let locationManager = CLLocationManager()
    
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
        self.setupBinding()
        self.viewModel.configureLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.showsUserLocation = true
        mapView.delegate = self
        self.configureMap()
    }
    
    private func setupBinding() {        
        // binding loading to vc
        self.viewModel.loading
            .bind(to: SVProgressHUD.rx.isAnimating).disposed(by: disposeBag)
        
        // binding items to items viewmodel
        self.viewModel
            .items
            .observeOn(MainScheduler.instance)
            .bind(to: items)
            .disposed(by: disposeBag)
        
        // observing errors to show
        self.viewModel
            .error
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (error) in
                SVProgressHUD.showError(withStatus: error)
            })
            .disposed(by: disposeBag)        
    }
    
    func configureMap() {
        // Remove any existing Annotation from the map, and add the new users
        self.viewModel.items
            .subscribe(onNext: { [weak self] users in
                guard let `self` = self else { return }
                self.mapView.removeAnnotations(self.mapView.annotations.filter { $0 is CustomPointAnnotation })
                for user in users {
                    if let latitude = user.latitude , let longitude = user.longitude,
                        let avatar = user.avatar, let url = URL(string: avatar) {
                        let customPoint = CustomPointAnnotation(title: user.name,
                                                                location: CLLocationCoordinate2DMake(latitude, longitude),
                                                                image: url)
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
        let imageView = UIImageView()
        imageView.kf.setImage(with: customAnnotation.imageURL) { result in
            switch result {
            case .success(let value):
                let size = CGSize(width: 25, height: 25)
                annotationView?.image = value.image.resized(to: size)
            case .failure:
                break
            }
        }
        return annotationView
    }

    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
      // Adjust the map to show all the annotations (user location and any destination annotation)
      mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
}

class CustomPointAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let imageURL: URL
    
    init(title: String?, location: CLLocationCoordinate2D, image: URL) {
        self.title = title
        self.coordinate = location
        self.imageURL = image
    }
}
