//
//  ChooseUserController.swift
//  SendShoesSMS
//
//  Created by GengJian on 2021/12/24.
//

import UIKit

protocol ChooseUserControllerDelegate {
    func didSelectedUser(_ vc: UIViewController, userInfo: String)
}

class ChooseUserController: UIViewController, UITableViewDataSource , UITableViewDelegate {

    public var delegate : ChooseUserControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Choose Sender User"
        self.navigationItem.rightBarButtonItem = addItem
        // Do any additional setup after loading the view.
        self.view.addSubview(self.userListView)
    }
    

    // MARK: - UI Method
    fileprivate var _addItem : UIBarButtonItem?
    lazy var addItem: UIBarButtonItem = {
        if (_addItem == nil) {
            _addItem = UIBarButtonItem.init(barButtonSystemItem: .add,
                                            target: self,
                                            action: Selector(("addButtonClicked")))
        }
        return _addItem!
    }()
    
    @objc func addButtonClicked() {
        debugPrint(#function)
        
        
    }
    
    fileprivate var _userListView : UITableView?
    lazy var userListView: UITableView = {
        if (_userListView == nil) {
            _userListView = UITableView.init(frame: self.view.bounds, style: .plain)
            _userListView?.backgroundColor = .cyan
            _userListView?.dataSource = self
            _userListView?.delegate = self
            _userListView?.register(UITableViewCell.self, forCellReuseIdentifier: "sizeCell")
        }
        return _userListView!
    }()
    
    
    // MARK: - UITableView DataSource/Delegate
    let sizeDataArray = [
        "36","37","38","39","40","41","42","43","44","45",
        "36.5","37.5","38.5","39.5","40.5","41.5","42.5","43.5","44.5","45.5"
    ].sorted { str1, str2 in
        let f1 = Float(str1)!
        let f2 = Float(str2)!
        return f1 < f2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sizeDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sizeCell", for: indexPath)
        let num = sizeDataArray[indexPath.row]
        cell.textLabel?.text = "\(num)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = sizeDataArray[indexPath.row]
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
        if let delegate = delegate {
            delegate.didSelectedUser(self, userInfo: user)
        }
    }

}
