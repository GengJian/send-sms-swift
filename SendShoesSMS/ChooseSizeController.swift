//
//  ChooseSizeController.swift
//  SendShoesSMS
//
//  Created by GengJian on 2021/12/24.
//

import UIKit

protocol ChooseSizeControllerDelegate {
    func didSelectedSize(_ vc: UIViewController, size: String)
}

class ChooseSizeController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
   public var delegate : ChooseSizeControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Choose Shoes Size"
        // Do any additional setup after loading the view.
        self.view.addSubview(self.sizeListView)
    }
    
    // MARK: - UI Method
    fileprivate var _sizeListView : UITableView?
    lazy var sizeListView: UITableView = {
        if (_sizeListView == nil) {
            _sizeListView = UITableView.init(frame: self.view.bounds, style: .plain)
            _sizeListView?.backgroundColor = .cyan
            _sizeListView?.dataSource = self
            _sizeListView?.delegate = self
            _sizeListView?.register(UITableViewCell.self, forCellReuseIdentifier: "sizeCell")
        }
        return _sizeListView!
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
        let num = sizeDataArray[indexPath.row]
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
        if let delegate = delegate {
            delegate.didSelectedSize(self, size: num)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
