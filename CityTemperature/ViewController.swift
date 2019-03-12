//
//  ViewController.swift
//  CityTemperature
//
//  Created by Santosh Kumari on 11/03/19.
//  Copyright © 2019 Santosh Kumari. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var arrofdata = [NSManagedObject]()
    var allValue = NSMutableArray()
    var ModelClassArray = [JointEventModel]()
    let session = URLSession.shared
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setTemp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrofdata.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath) as! TableCell
        let innerdata = arrofdata[indexPath.row]
        cell.cityname.text = innerdata.value(forKey: "name") as? String
        cell.templabel.text = innerdata.value(forKey: "temperature") as? String
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict = arrofdata[indexPath.row]
        let storybd = UIStoryboard.init(name: "Main", bundle: nil)
        let DetailsVC : DetailController = storybd.instantiateViewController(withIdentifier: "DetailController") as! DetailController
        DetailsVC.arrofDict = dict
        self.navigationController?.pushViewController(DetailsVC, animated: true)
    }
    
    func createData(){
        
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Now let’s create an entity and new user records.
        let userEntity = NSEntityDescription.entity(forEntityName: "City", in: managedContext)!
        
        //final, we need to add some data to our newly created record for each keys using
        //here adding 5 data with loop
        arrofdata.removeAll()
        for i in 0..<ModelClassArray.count {
            let objmodel = ModelClassArray[i]
            let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
            user.setValue(objmodel.RowName, forKeyPath: "name")
            user.setValue(objmodel.RowMaxTemp, forKey: "maxtemp")
            user.setValue(objmodel.RowMinTemp, forKey: "mintemp")
            user.setValue(objmodel.RowTemp, forKey: "temperature")
            user.setValue(objmodel.Rowhumidity, forKey: "humidity")
            user.setValue(objmodel.Rowdescription, forKey: "weatherdescription")
            arrofdata.append(user)
        }
        
        //Now we have set all the values. The next step is to save them inside the Core Data
        
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        self.tableView.reloadData()
    }
    
    func setTemp()  {
       
        let remoteHostStatusIntrnet:Bool   = obj_app.checkNetworkStatus()
        
        obj_app.startActivity()
        
        if remoteHostStatusIntrnet == true
        {
            //http://api.openweathermap.org/data/2.5/weather?id=4163971&APPID=a8a6aa00e32ba6ca3ab30aecc084fd90
            let urlArr = ["http://api.openweathermap.org/data/2.5/weather?id=4163971&APPID=a8a6aa00e32ba6ca3ab30aecc084fd90","http://api.openweathermap.org/data/2.5/weather?id=2147714&APPID=a8a6aa00e32ba6ca3ab30aecc084fd90","http://api.openweathermap.org/data/2.5/weather?id=2174003&APPID=a8a6aa00e32ba6ca3ab30aecc084fd90"]
            
            for i in urlArr {
                
                DispatchQueue.main.async(execute: { () -> Void in
                    do
                    {
                        self.session.dataTask(with: URL(string: i)!, completionHandler: { (data : Data? , resp : URLResponse? , error: Error?) -> Void in
                            if let jsondata = data {
                                let jsonBase = try? JSONSerialization.jsonObject(with: jsondata, options: JSONSerialization.ReadingOptions.mutableContainers)
                                print(jsonBase as! NSDictionary)
                                self.allValue.add(jsonBase as! NSDictionary)
                                if self.allValue.count == 3 {
                                    obj_app.stopAcitivity()
                                    DispatchQueue.main.async {
                                      self.ModelClassArray = JointEventModel.getvaluesOfSelectTemp(arrOfListData: self.allValue)
                                      self.createData()
                                    }
                                }
                            }
                        }).resume()
                    }
                    catch
                    {
                        obj_app.stopAcitivity()
                        print(error)
                
                    }
                })
    
            }
            
        }
        else
        {
            obj_app.stopAcitivity()
            self.alertViewFromApp(messageString: "No Network available in device ,please try to connect with internet!")
        }
        
    
    }
    
    @IBAction func RefreshTableView(_ sender: UIBarButtonItem) {
        self.allValue.removeAllObjects()
        setTemp()
    }
    
    func alertViewFromApp(messageString strMessage: String)
    {
        let alert = UIAlertController(title:"Message", message:strMessage, preferredStyle: UIAlertController.Style.alert)
        self.present(alert, animated: true, completion: nil)
    }

}

