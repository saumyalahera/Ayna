//
//  ViewController.swift
//  Ayna
//
//  Created by Saumya Lahera on 4/15/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var accounts: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        accounts.dataSource = self
        accounts.delegate = self
        //accounts.register(AccountLabelCell.self, forCellReuseIdentifier: "accountCell")
        self.title = "Shaders"
    }
}

/**
 This is for table view controller
 */
extension ViewController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! AccountLabelCell
        //cell.textLabel?.text = "Saumya Lahera"
        cell.projectTitle.text = "Meegggiiimm"
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

class AccountLabelCell:UITableViewCell {
    
    @IBOutlet weak var projectTitle: UILabel!
}

