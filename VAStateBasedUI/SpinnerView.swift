//
//  SpinnerView.swift
//  VAManagerBuddy
//
//  Created by Vikash Anand on 23/02/20.
//  Copyright © 2020 Vikash Anand. All rights reserved.
//

import UIKit

final class SpinnerView: UIView {
    
    private lazy var container = configure(UIView()) {
        $0.backgroundColor = UIColor.colorFromHex(rgbValue:0xffffff, alpha: 0.5)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var loadingView = configure(UIView()) {
        $0.backgroundColor = UIColor.colorFromHex(rgbValue:0x444444, alpha: 0.7)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var activityIndicator = configure(UIActivityIndicatorView()) {
        $0.style = UIActivityIndicatorView.Style.whiteLarge
        $0.hidesWhenStopped = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
        self.activityIndicator.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private func setupView() {
        
        self.loadingView.addSubview(self.activityIndicator)
        self.container.addSubview(self.loadingView)
        self.addSubview(self.container)
        
        NSLayoutConstraint.activate([
            self.activityIndicator.widthAnchor.constraint(equalToConstant: 40),
            self.activityIndicator.heightAnchor.constraint(equalToConstant: 40),
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.loadingView.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.loadingView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.loadingView.widthAnchor.constraint(equalToConstant: 80),
            self.loadingView.heightAnchor.constraint(equalToConstant: 80),
            self.loadingView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.loadingView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.container.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.container.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: self.container.bottomAnchor),
            self.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: self.container.trailingAnchor)
        ])
    }
    
    func showSpinner(inView : UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        inView.addSubview(self)
        NSLayoutConstraint.activate([
                   self.topAnchor.constraint(equalTo: inView.safeAreaLayoutGuide.topAnchor),
                   self.leadingAnchor.constraint(equalTo: inView.leadingAnchor),
                   inView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                   inView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: self.trailingAnchor)
               ])
    }
    
    func removeSpinner() {
        self.activityIndicator.stopAnimating()
        if self.superview != nil {
            self.removeFromSuperview()
        }
    }
}

extension SpinnerView: AddableRemoveable {
    
    func addAsSubView(inView parentView: UIView) {
        self.showSpinner(inView: parentView)
    }
    
    func removeAsSubViewFromParentView() {
        self.removeSpinner()
    }
}
