//
//  RootViewController.swift
//  VAStateBasedUIUpdates
//
//  Created by Vikash Anand on 07/03/20.
//  Copyright © 2020 Vikash Anand. All rights reserved.
//

import UIKit

final class RootViewController: UIViewController {
    
    private var viewModel = MemeberViewModel(NetworkFetcher())
    private var members: [Member]?
    
    private enum State {
        case pending
        case loading(spinnerView: SpinnerView)
        case failed(retryView: NoConnectionView)
        case loaded(members: [Member], inView: EmployeeTableView)
    }
    
    private var state: State = .pending {
        didSet {
            switch state {
            case .pending: visibleView = nil
            case .loading(let spinner): visibleView = spinner
            case .failed(let retryView): visibleView = retryView
            case .loaded(let members, let employeeTableView):
                employeeTableView.dataSource = self
                visibleView = employeeTableView
                self.members = members
                employeeTableView.reloadData()
            }
        }
    }
    
    var visibleView: AddableRemoveable? {
        willSet { visibleView?.removeAsSubViewFromSuperView() }
        didSet { if let visibleView = visibleView { visibleView.addAsSubView(inView : view) } }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Members"
        self.loadMembers()
    }
    
    private func checkIfFirstLaunch() {
        
    }
    
    private func loadMembers() {
        
        state = .loading(spinnerView: SpinnerView())
        
        viewModel.getMembers { (result: Result<MemberResponse, DataFetchError>) in
            switch result {
            case .success(let memberResponse):
                guard let members = memberResponse.results else { return }
                
//                var filteredMembers: [Member] = []
//                for member in members {
//                    if member.isMale {
//                        filteredMembers.append(member)
//                    }
//                }
                
                let filteredMembers = members.filteredMaleMembers
                
                self.state = .loaded(members: filteredMembers, inView: EmployeeTableView(frame: .zero, style: .plain))
            case .failure(let error):
                self.state = .failed(retryView: NoConnectionView(retryAction: self.retry))
                print("Error: \(String(describing:error.errorDescription))")
            }
        }
    }
    
    
    @objc private func retry() {
        loadMembers()
    }
}

extension RootViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.members?.count ?? 0
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard let members = self.members else { return cell }
        
        //let member = members[indexPath.row] as Member
        guard let member = members.first else { return cell }
        cell.textLabel?.text = Value(at: indexPath, from: member)?.title
        
//        if indexPath.row == 0 {
//            cell.textLabel?.text = member.name?.first
//        } else if indexPath.row == 1 {
//            cell.textLabel?.text = member.name?.last
//        } else if indexPath.row == 2 {
//            cell.textLabel?.text = member.email
//        } else if indexPath.row == 3 {
//            cell.textLabel?.text = member.gender
//        }
        
        return cell
    }
}


private enum Value {
    case firstName(from: Member)
    case lastName(from: Member)
    case emailName(from: Member)
    case genderName(from: Member)
    
    var title: String {
        switch self {
        case .firstName(let member):
            return member.name?.first ?? ""
        case .lastName(let member):
            return member.name?.last ?? ""
        case .emailName(let member):
            return member.email ?? ""
        case .genderName(let member):
            return member.gender ?? ""
        }
    }
}

extension Value {
    
    init?(at indexPath: IndexPath, from member: Member) {
        
        switch indexPath.row {
        case 0:
            self = .firstName(from: member)
        case 1:
            self = .lastName(from: member)
        case 2:
            self = .emailName(from: member)
        case 3:
            self = .genderName(from: member)
        default:
            fatalError("Invalid index path")
        }
    }
}


