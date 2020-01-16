//
//  DetailViewController.swift
//  test
//
//  Created by PENA SANCHEZ Edwin Jose
//

import CoreLocation
import Kingfisher
import MapKit
import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var mapView: MKMapView!
    
    var userDTO: UserDTO?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = self.userDTO {
            self.setupDetail(with: user)
        }
    }
    
    func setupDetail(with user: UserDTO) {
        if let avatar = user.avatar, let url = URL(string: avatar) {
            self.avatarImage.kf.setImage(with: url)
        }
        self.addCustomLabel(text: user.name, font: UIFont.boldSystemFont(ofSize: 15))
        self.addCustomLabel(text: user.motion?.rawValue, font: UIFont.systemFont(ofSize: 15))
        self.addCustomLabel(text: user.timestamp?.offsetFrom(date: Date()), font: UIFont.systemFont(ofSize: 15))
        
        if let latitude = user.latitude, let longitude = user.longitude {
            let customPoint = CustomPointAnnotation(user: user,
                                                    coordinate: CLLocationCoordinate2DMake(latitude, longitude))
            self.setupMap(latitude, longitude, annotation: customPoint)
        }
    }
    
    private func setupMap(_ latitude: Double, _ longitude: Double, annotation: CustomPointAnnotation) {
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        self.mapView.setRegion(region, animated: true)
        
        /// add annotation
        self.mapView.addAnnotation(annotation)
    }
    
    private func addCustomLabel(text: String?, font: UIFont) {
        guard let text = text, text != "null" else { return }
        let label = UILabel()
        label.numberOfLines = 0
        if self.traitCollection.userInterfaceStyle == .dark {
            label.textColor = UIColor.white
        } else {
            label.textColor = UIColor.black
        }
        label.text = text.trimmingCharacters(in: .whitespaces)
        label.font = font
        label.textAlignment = .justified
        self.stackView.addArrangedSubview(label)
    }
}
