//
//  ChooseUserController.swift
//  SendShoesSMS
//
//  Created by GengJian on 2021/12/24.
//

import UIKit
import CoreData

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
    
    override func viewDidAppear(_ animated: Bool) {
        self.userDataArray = checkAllUsers().sorted { user1, user2 in
            user2.id > user1.id  //按照身份证排序
        }
        self.userListView.reloadData()
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
        
        let bundle = Bundle(for: Self.self)
        let sb = UIStoryboard.init(name: "Main", bundle: bundle)
        let identifier = "AddUserController"
        let vc = sb.instantiateViewController(withIdentifier: identifier)
        
        self.navigationController?.show(vc, sender: nil)
     
    }
    
    fileprivate var _userListView : UITableView?
    lazy var userListView: UITableView = {
        if (_userListView == nil) {
            _userListView = UITableView.init(frame: self.view.bounds, style: .plain)
            _userListView?.backgroundColor = .cyan
            _userListView?.dataSource = self
            _userListView?.delegate = self
            
            let nib = UINib.init(nibName: "UserListTableViewCell", bundle: .main)
            _userListView?.register(nib, forCellReuseIdentifier: "sizeCell")
        }
        return _userListView!
    }()
    
    
    // MARK: - UITableView DataSource/Delegate
    var userDataArray = Array<UserModel>.init()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sizeCell", for: indexPath) as! UserListTableViewCell
        let user = userDataArray[indexPath.row]
       
        cell.setModel(user)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = userDataArray[indexPath.row]
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
        if let delegate = delegate {
            let firstName = user.firstName ?? "FirstName"
            let lastName = user.lastName ?? "LastName"
            let firstId = user.firstId ?? "FirstId"
            let lastId = user.lastId ?? "LastId"
            
            let userInfo = firstName + " " + lastName + "+" + firstId + lastId
            delegate.didSelectedUser(self, userInfo: userInfo)
        }
    }

    /// 从CoreData中查询所有的用户
    func checkAllUsers() -> Array<UserModel> {
        // Fetching models from CoreData
        var users : Array<UserModel> = []
        do {
            let robotsRequest: NSFetchRequest<UserModel> = UserModel.fetchRequest()
            let sort = NSSortDescriptor(key: "id", ascending: true)
            robotsRequest.sortDescriptors = [sort]
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            users = try context.fetch(robotsRequest)
                print(users)
                        } catch {
                            print("Failed fetching")
                        }
        return users
    }
}
