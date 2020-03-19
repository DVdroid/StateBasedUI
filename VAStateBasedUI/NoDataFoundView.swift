//
//  NoDataFoundView.swift
//  VAStateBasedUI
//
//  Created by TIAA on 18/03/20.
//  Copyright © 2020 Vikash Anand. All rights reserved.
//

import UIKit

final class NoDataFoundView: UIView {
    
    var retryAction: (() -> Void)
    
    lazy var noDataImageView = configure(UIImageView()) {
        $0.image = UIImage(named: "not_found_icon")
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var button = configure(UIButton()) {
        $0.layer.borderColor = UIColor(red: 43/255, green: 33/255, blue: 38/255, alpha: 1.0).cgColor
        $0.layer.borderWidth = 2.0
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Retry", for: .normal)
        $0.setTitleColor(UIColor(red: 43/255, green: 33/255, blue: 38/255, alpha: 1.0), for: .normal)
        $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    init(retryAction: @escaping (() -> Void)) {
        self.retryAction = retryAction
        super.init(frame: .zero)
        
        self.backgroundColor = UIColor(red: 241/255, green: 179/255, blue: 67/255, alpha: 1.0)
        addSubview(noDataImageView)
        addSubview(button)
        configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented...")
    }
    
    private func configureSubviews() {
        
        NSLayoutConstraint.activate([
            self.noDataImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.noDataImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.trailingAnchor.constraint(equalTo: self.noDataImageView.trailingAnchor),
            self.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: self.noDataImageView.bottomAnchor)
            ])
        
        NSLayoutConstraint.activate([
            self.button.widthAnchor.constraint(equalToConstant: 90),
            self.button.heightAnchor.constraint(equalToConstant: 35),
            self.button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: self.button.bottomAnchor, constant: 50)
            ])
    }
    
    @objc func buttonTapped() {
        self.retryAction()
    }
    
    func showNoDataFoundView(inView parentView: UIView) {
        
        if self.superview == nil {
            self.translatesAutoresizingMaskIntoConstraints = false
            parentView.addSubview(self)
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor),
                self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
                parentView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                parentView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: self.trailingAnchor)
                ])
        }
    }
    
    func removeNoDataFoundView() {
        if self.superview != nil {
            self.removeFromSuperview()
        }
    }
}

extension NoDataFoundView: AddableRemoveable {
    
    func addAsSubView(inView parentView: UIView) {
        self.showNoDataFoundView(inView: parentView)
    }
    
    func removeAsSubViewFromParentView() {
        self.removeNoDataFoundView()
    }
}
