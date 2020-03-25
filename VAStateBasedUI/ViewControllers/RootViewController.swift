//
//  RootViewController.swift
//  VAStateBasedUI
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
        case failedDueToNoConnection(retryView: NoConnectionView)
        case failedDueToNoData(retryView: NoDataFoundView)
        case loaded(members: [Member], inView: EmployeeTableView)
    }
    
    private var state: State = .pending {
        didSet {
            switch state {
            case .pending: visibleView = nil
                
            case .loading(let spinner):
                isRefreshBarButtonItemEnabled = false
                visibleView = spinner
                
            case .failedDueToNoConnection(let retryView):
                visibleView = retryView
                
            case .failedDueToNoData(let retryView):
                visibleView = retryView
                
            case .loaded(let members, let employeeTableView):
                isRefreshBarButtonItemEnabled = true
                visibleView = employeeTableView
                employeeTableView.dataSource = self
                self.members = members
                employeeTableView.reloadData()
            }
        }
    }
    
    /* Property to Abstract the logic to enable/disable 'self.navigationItem.rightBarButtonItem' */
    var isRefreshBarButtonItemEnabled: Bool = false {
        didSet {
            self.navigationItem.rightBarButtonItem?.isEnabled = isRefreshBarButtonItemEnabled
        }
    }
    
    /* Property to Abstract the logic to add/remove various subviews of self.view */
    var visibleView: AddableRemoveable? {
        willSet { visibleView?.removeAsSubViewFromParentView() }
        didSet { if let visibleView = visibleView { visibleView.addAsSubView(inView : view) } }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Members"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reload",
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector(self.reload))
        self.loadMembers()
    }
    
    private func loadMembers() {
        
        state = .loading(spinnerView: SpinnerView())
        
        viewModel.getMembers { (result: Result<MemberResponse, DataFetchError>) in
            switch result {
            case .success(let memberResponse):
                guard let members = memberResponse.results else { return }
                let filteredMembers = members.filteredMaleMembers

                self.state = .loaded(members: filteredMembers,
                                     inView: EmployeeTableView(frame: .zero, style: .plain))
                
            case .failure(let error):
                switch error {
                case .noInternet:
                    let noConnectionView = NoConnectionView(retryAction: self.retry)
                    self.state = .failedDueToNoConnection(retryView: noConnectionView)
                case .noRecords, .badResponse:
                    let noDataFoundView = NoDataFoundView(retryAction: self.retry)
                    self.state = .failedDueToNoData(retryView: noDataFoundView)
                default:
                    print("Error: \(String(describing:error.errorDescription))")
                }
            }
        }
    }
    
    @objc private func reload() {
        self.loadMembers()
    }
    
    @objc private func retry() {
        loadMembers()
    }
}

extension RootViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard !self.members.isNilOrEmpty, let member = self.members?.first else { return cell }
        cell.textLabel?.text = Value(at: indexPath, from: member)?.title
        
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


