//
//  TableViewController.swift
//  SolievWeather
//
//  Created by user on 23.09.2021.
//

import UIKit
import Alamofire
import SwiftyJSON

class TableViewController: UITableViewController {
    
    @IBOutlet weak var cityTableView: UITableView!
    var cityName = ""
    
    struct Cities {
        var cityName = ""
        var cityTemp = 0.0
    }
    
    var cityTempArray: [Cities] = []
    
    func currentWeather(city: String) {
        let url = "http://api.weatherapi.com/v1/current.json?key=4d472dc4c1924e5bab872302212309&q=\(city)"
        AF.request(url, method: .get).validate().responseJSON { response in switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let name = json["location"]["name"].stringValue
                    let temp = json["current"]["temp_c"].doubleValue
                    self.cityTempArray.append(Cities(cityName: name, cityTemp: temp))
                    self.cityTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    @IBAction func addCityAction(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Add", message: "Write a name of city", preferredStyle: .alert)
        alert.addTextField { (textField) in textField.placeholder = "Moscow"}
        
        let cancelAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        let newCityAction = UIAlertAction(title: "Add", style: .default) { (action) in let name = alert.textFields![0].text
            
            
            
            self.currentWeather(city: name!)
        }
        alert.addAction(cancelAction)
        alert.addAction(newCityAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityTableView.delegate = self
        cityTableView.dataSource = self
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! citiesNameCell
        
        cell.cityName.text = cityTempArray[indexPath.row].cityName
        cell.cityTemp.text = String(cityTempArray[indexPath.row].cityTemp)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cityName = cityTempArray[indexPath.row].cityName
        performSegue(withIdentifier: "detailVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? detailVC {
            vc.cityName = cityName
        }
    }
}
