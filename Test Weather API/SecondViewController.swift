//
//  SecondViewController.swift
//  Test Weather API
//
//  Created by Максим Вильданов on 17.07.2018.
//  Copyright © 2018 Максим Вильданов. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var buttonOutlet: UIButton!
    @IBOutlet weak var cityLabelOutlet: UITextField!
    
    var items = [String?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(items)
        notificationAndButton()
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func notificationAndButton() {
        buttonOutlet.layer.cornerRadius = 10
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: nil) { (nc) in
            self.view.frame.origin.y = -120
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: nil) { (nc) in
            self.view.frame.origin.y = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "return" {
            
            if let text = cityLabelOutlet.text {
                if items.contains(text) {
                    let alert = UIAlertController(title: "Warning", message: "This city is already in the table", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(action)
                    present(alert, animated: true)
                    cityLabelOutlet.text = ""
                    return
                }
                if Int(text) != nil {
                    let alert = UIAlertController(title: "Warning", message: "Filed \"city\" must be just a string", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(action)
                    present(alert, animated: true)
                    cityLabelOutlet.text = ""
                    return
                }
                if text.isEmpty {
                    let alert = UIAlertController(title: "Warning", message: "Text field is empty", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(action)
                    present(alert, animated: true)
                    return
                }
                let upperCity = cityLabelOutlet.text?.capitalized
                let session = URLSession.shared
                let string = "http://api.openweathermap.org/data/2.5/weather?q="+upperCity!+"&units=metric&APPID=efdce347ac4b70d44d74b916d26dc519"
                var item : Model?
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
                            } catch {
                                print(error.localizedDescription)
                                let alert = UIAlertController(title: "Warning", message: "City is not in database", preferredStyle: .alert)
                                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                alert.addAction(action)
                                self.present(alert, animated: true)
                                return
                            }
                        }
                    }
                    task.resume()
                    } else {
                        let alert = UIAlertController(title: "Warning", message: "Please enter the city correctly", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alert.addAction(action)
                        self.present(alert, animated: true)
                        return
                    }
                items.append(text)
            
        }
        (segue.destination as! TableTableViewController).cities = items as! [String]
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

}
