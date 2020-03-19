//
//  NoConnectionView.swift
//  VAManagerBuddy
//
//  Created by Vikash Anand on 23/02/20.
//  Copyright © 2020 Vikash Anand. All rights reserved.
//

import UIKit

final class NoConnectionView: UIView {
    
    var retryAction: (() -> Void)
    
    lazy var noConnectionImageView = configure(UIImageView()) {
        $0.image = UIImage(named: "No_Connection")
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var button = configure(UIButton()) {
        $0.layer.borderColor = UIColor.cyan.cgColor
        $0.layer.borderWidth = 2.0
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Retry", for: .normal)
        $0.setTitleColor(UIColor.darkGray, for: .normal)
        $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    init(retryAction: @escaping (() -> Void)) {
        self.retryAction = retryAction
        super.init(frame: .zero)
        
        self.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 230/255, alpha: 1.0)
        addSubview(noConnectionImageView)
        addSubview(button)
        configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented...")
    }
    
    private func configureSubviews() {
        
        NSLayoutConstraint.activate([
            self.noConnectionImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.noConnectionImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.trailingAnchor.constraint(equalTo: self.noConnectionImageView.trailingAnchor),
            self.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: self.noConnectionImageView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.button.widthAnchor.constraint(equalToConstant: 90),
            self.button.heightAnchor.constraint(equalToConstant: 35),
            self.button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: self.button.bottomAnchor, constant: 75)
        ])
    }
    
    @objc func buttonTapped() {
        self.retryAction()
    }
    
    func showNoConnectionView(inView : UIView) {
        
        if self.superview == nil {
            self.translatesAutoresizingMaskIntoConstraints = false
            inView.addSubview(self)
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: inView.safeAreaLayoutGuide.topAnchor),
                self.leadingAnchor.constraint(equalTo: inView.leadingAnchor),
                inView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                inView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
        }
    }
    
    func removeNoConnectionView() {
        if self.superview != nil {
            self.removeFromSuperview()
        }
    }
}

extension NoConnectionView: AddableRemoveable {
    
    func addAsSubView(inView parentView: UIView) {
        self.showNoConnectionView(inView: parentView)
    }
    
    func removeAsSubViewFromParentView() {
        self.removeNoConnectionView()
    }
}
