//
//  ListViewController.swift
//  test
//
//  Created by PENA SANCHEZ Edwin Jose on 13/01/2020.
//  Copyright © 2020 safe365. All rights reserved.
//

import UIKit
import CoreLocation
import RxCoreLocation
import RxSwift
import RxCocoa
import SVProgressHUD

class ListViewController: UIViewController {
    
    // IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
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
    }
    
    private func setupBinding() {
        self.items.bind(to: tableView.rx.items(cellIdentifier: "cell",
                                          cellType: UserCell.self)) {  (row, dto, cell) in
                                            cell.setup(user: dto)
        }.disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell
            .subscribe(onNext: ({ (cell,indexPath) in
                cell.alpha = 0
                let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 0, 0)
                cell.layer.transform = transform
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7,
                               initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                                cell.alpha = 1
                                cell.layer.transform = CATransform3DIdentity
                }, completion: nil)
            })).disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                let dto = self?.items.map { $0[indexPath.row] }
                
            }).disposed(by: disposeBag)
        
        tableView
        .rx.setDelegate(self)
        .disposed(by: disposeBag)
        
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
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
}
