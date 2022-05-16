//
//  CardViewController.swift
//  finalproject
//
//  Created by Yi Zhang && Yutong Gu on 2022-04-16.
//

import UIKit
import FirebaseDatabase

class CardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var animals = [AnimalResponse](){
        didSet{
        print(animals)
        }
        
    }
    
    let titles:[String] = []
    let testPic:UIImage = UIImage(named: "card.png")!
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "cell"
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register the table view cell class and its reuse id
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
            
        // (optional) include this line if you want to remove the extra empty cell divider lines
        // self.tableView.tableFooterView = UIView()

        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
    }
        
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("In table view, list count: \(self.animals.count)")
        return self.animals.count
    }
        
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
//        // create a new cell if needed or reuse an old one
//        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)! as UITableViewCell
//
//        // set the text from the data model
//        cell.textLabel?.text = self.animals[indexPath.row].name
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for:indexPath) as! CardCell
        cell.configure(picture: UIImage(named:animals[indexPath.row].image)!,
                       title: animals[indexPath.row].name,
                       age: animals[indexPath.row].age,
                       gender: animals[indexPath.row].gender,
                       description: animals[indexPath.row].description)
        return cell
    }
        
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    

}

