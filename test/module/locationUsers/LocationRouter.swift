//
//  LocationRouter.swift
//  test
//
//  Created by PENA SANCHEZ Edwin Jose
//

import UIKit

// MARK: - Routes

enum LocationNavegation {
    case detailLocation(user: UserDTO)
}

protocol LocationRouter {
    var viewController: UIViewController? { get }
    init(viewController: UIViewController)
    func navigate(to route: LocationNavegation)
}

class LocationRouterImp: LocationRouter {
    weak var viewController: UIViewController?

    required init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func navigate(to route: LocationNavegation) {
        switch route {
        case .detailLocation(let user):
            let storyboard = UIStoryboard(name: "Location", bundle: nil)
            if let controller = storyboard.instantiateViewController(withIdentifier: "DetailViewControllerID") as? DetailViewController {
                controller.userDTO = user
                self.viewController?.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
}
