//
//  ListViewController.swift
//  test
//
//  Created by PENA SANCHEZ Edwin Jose on 13/01/2020.
//  Copyright © 2020 safe365. All rights reserved.
//

import RxCocoa
import RxSwift
import SVProgressHUD
import UIKit

class ListViewController: UIViewController {
    // IBOutlet
    @IBOutlet var tableView: UITableView!
    let disposeBag = DisposeBag()
    var viewModel: LocationViewModel
    var router: LocationRouterImp?
    var timer: Timer?
    
    public init(viewModel: LocationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder decoder: NSCoder) {
        viewModel = LocationViewModel()
        super.init(coder: decoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        router = LocationRouterImp(viewController: self)
        setupBinding()
        setupTableView()
        viewModel.configureLocationManager()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 10, target: self,
                                         selector: #selector(updateLocation),
                                         userInfo: nil, repeats: true)
        } else {
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 10, target: self,
                                         selector: #selector(updateLocation),
                                         userInfo: nil, repeats: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
    }
    
    private func setupBinding() {
        // binding loading to vc
        viewModel.loading
            .bind(to: SVProgressHUD.rx.isAnimating).disposed(by: disposeBag)
        
        // observing errors to show
        viewModel
            .error
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { error in
                SVProgressHUD.showError(withStatus: error)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        viewModel.items.bind(to: tableView.rx.items(cellIdentifier: "cell",
                                                    cellType: UserCell.self)) { _, dto, cell in
            cell.setup(user: dto)
        }.disposed(by: disposeBag)
        
        tableView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(UserDTO.self)
            .subscribe(onNext: { [weak self] userDTO in
                self?.router?.navigate(to: .detailLocation(user: userDTO))
            }).disposed(by: disposeBag)
    }
    
    @objc fileprivate func updateLocation(timer: Timer) {
        viewModel.configureLocationManager()
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
}
