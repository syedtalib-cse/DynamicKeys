//
//  ViewController.swift
//  DynamicKeys
//
//  Created by Talib on 16/09/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var dataTV: UITableView!
    var decodedResult:DecodedArray!
    
    
    let jsonString = """
    {
      "S001": {
        "firstName": "Tony",
        "lastName": "Stark"
      },
      "S002": {
        "firstName": "Peter",
        "lastName": "Parker"
      },
      "S003": {
        "firstName": "Bruce",
        "lastName": "Wayne"
      }
    }
    """
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let jsonData = Data(jsonString.utf8)
        decodedResult = try! JSONDecoder().decode(DecodedArray.self, from: jsonData)
        dataTV.delegate = self
        dataTV.dataSource = self
        dump(decodedResult.array)
        dataTV.register(UITableViewCell.self, forCellReuseIdentifier:"cell")
    }


}


extension ViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return decodedResult.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier:"cell", for:indexPath) as UITableViewCell
        cell.textLabel?.text = decodedResult.array[indexPath.row].firstName
        
        return cell
    }
  
    
    
}
