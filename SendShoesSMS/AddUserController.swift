//
//  AddUserController.swift
//  SendShoesSMS
//
//  Created by GengJian on 2021/12/24.
//

import UIKit
import CoreData

class AddUserController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Add New User"
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstIdTextField: UITextField!
    @IBOutlet weak var lastIdTextField: UITextField!
    
    @IBAction func addUserButtonClicked(_ sender: Any) {
        // 点击保存按钮，存入CoreData
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let robotEntity = NSEntityDescription.entity(forEntityName: "UserModel", in: context)
        let robot = UserModel(entity: robotEntity!, insertInto: context)
        robot.id = Int32(checkAllUsersCount() + 1)
        robot.firstName = self.firstNameTextField.text?.replacingOccurrences(of: " ", with: "")
        robot.lastName = self.lastNameTextField.text?.replacingOccurrences(of: " ", with: "")
        robot.firstId = self.firstIdTextField.text?.replacingOccurrences(of: " ", with: "")
        robot.lastId = self.lastIdTextField.text?.replacingOccurrences(of: " ", with: "")
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
        
        print(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.applicationSupportDirectory,
                                                  FileManager.SearchPathDomainMask.userDomainMask, true))
    }
    
    
    /// 从CoreData中查询所有的用户
    func checkAllUsersCount() -> Int {
        // Fetching models from CoreData
        var count = 0
        do {
            let robotsRequest: NSFetchRequest<UserModel> = UserModel.fetchRequest()
            let sort = NSSortDescriptor(key: "id", ascending: true)
            robotsRequest.sortDescriptors = [sort]
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            count = try context.fetch(robotsRequest).count
                        print("数据库中现有数量\(count)")
                    } catch {
                        print("Failed fetching")
                    }
        return count
    }
    
    
}
