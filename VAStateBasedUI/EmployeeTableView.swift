//
//  EmployeeTableView.swift
//  VAStateBasedUIUpdates
//
//  Created by Vikash Anand on 07/03/20.
//  Copyright © 2020 Vikash Anand. All rights reserved.
//

import UIKit

class EmployeeTableView: UITableView {}

extension EmployeeTableView: AddableRemoveable {
    
    private func configureEmployeeTableView() {
        self.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.estimatedRowHeight = UITableView.automaticDimension
        self.rowHeight = 80.0
    }
    
    func addAsSubView(inView parentView: UIView) {
        self.configureEmployeeTableView()
        self.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(self)
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 0),
            self.topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor, constant: 0),
            parentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            parentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
    }
    
    func removeAsSubViewFromSuperView() {
        if self.superview != nil {
            self.removeFromSuperview()
        }
    }
}
