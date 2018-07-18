//
//  TableTableViewController.swift
//  Test Weather API
//
//  Created by Максим Вильданов on 16.07.2018.
//  Copyright © 2018 Максим Вильданов. All rights reserved.
//

import UIKit

class TableTableViewController: UITableViewController {
    
    var timeRefreshing = 0
    var items = [Model]()
    var currentCity : Model?
    var cities = ["London", "Madrid","Dublin", "Tivat"]

    override func viewDidLoad() {
        super.viewDidLoad()
//        items = [Model(time: "21:45" , city: "London" , deg: "70°" )]
        getData()
        tableView.separatorColor = .clear
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.tableView.addSubview(self.refreshTable)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        let item = items[indexPath.row]
        
        if let name = item.name, let dt = item.dt?.unixTimeToString(), let temp = item.main.temp?.rounded() {
                cell.cityNameOutlet.text = name
                cell.currentTimeOutlet.text = dt
                cell.degriesInCelsOutlet.text = String(Int(temp)) + "°"
            if timeRefreshing > 1 && item.name == currentCity?.name {
                if let dt = currentCity?.dt?.unixTimeToString(), let temp = currentCity?.main.temp?.rounded() {
                    print("refresh ready")
                    cell.currentTimeOutlet.text = dt
                    cell.degriesInCelsOutlet.text = String(Int(temp)) + "°"
                }
                
                currentCity = nil
            }
        }
        return cell
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            for i in cities.indices {
                if let item = items[indexPath.row].name {
                    if item == cities[i] {
                        cities.remove(at: i)
                        break
                    }
                }
            }
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            print(cities)
        }
    }
    
    func getCityApi(city: String){
        if Int(city) != nil {
            return
        }
        let upperCity = city.capitalized
        let session = URLSession.shared
        var item : Model?
        let string = "http://api.openweathermap.org/data/2.5/weather?q="+upperCity+"&units=metric&APPID=efdce347ac4b70d44d74b916d26dc519"
        if let url = URL(string: string) {
            let task = session.dataTask(with: url) { (data, response, error) in
                guard error == nil else {
                    print("DataTask error: \(error!.localizedDescription)")
                    return
                }
                if let curdata = data {
                    do {
                        let dictionary = try JSONDecoder().decode(Model.self, from: curdata)
                        item = dictionary
                        if let city = item,  self.timeRefreshing < 2 {
                            self.items.append(city)
                        } else {
                            self.currentCity = item
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            task.resume()
        } else {
            let alert = UIAlertController(title: "Warning", message: "Please enter the city correctly", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
    }
    
    func getData() {
        timeRefreshing += 1
        for  city in cities {
            getCityApi(city: city)
        }
        
    }
    
    var refreshTable: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.white
        
        return refreshControl
    }()
    
    @objc func handleRefresh(refreshControl: UIRefreshControl) {
        DispatchQueue.main.async {
            self.getData()
            refreshControl.endRefreshing()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "push" {
        }
        (segue.destination as! SecondViewController).items = cities
        
    }
    
}

extension Double {
    func unixTimeToString() -> String {
        let unix = self
        let date = Date(timeIntervalSince1970: unix)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
}
