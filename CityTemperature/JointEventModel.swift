//
//  JointEventModel.swift
//  EverLynked_30July18
//
//  Created by Khushboo Gupta on 15/11/18.
//  Copyright © 2018 Khushboo Gupta. All rights reserved.
//

import UIKit

class JointEventModel: NSObject {
  
    var RowID : NSNumber!
    var RowName : String!
    var RowImage : String!
    var RowMaxTemp : String!
    var RowMinTemp   : String!
    var RowTemp : String!
    var Rowhumidity : String!
    var Rowdescription : String!
    
    class func getvaluesOfSelectTemp(arrOfListData : NSArray)-> [JointEventModel]
    {
        var selectTempModelArray = [JointEventModel]()
        
        for index in 0..<arrOfListData.count
        {
            let aboutModel:JointEventModel  =  JointEventModel()
            let dict = arrOfListData.object(at: index) as! NSDictionary
            let maindict = dict.value(forKey: "main") as! NSDictionary
            let weatherdict = (dict.value(forKey: "weather") as! NSArray)[0] as! NSDictionary
            aboutModel.RowID = dict.value(forKey: "id") as? NSNumber
            aboutModel.RowName = "\((dict.value(forKey: "name")) ?? "")"
            aboutModel.RowMaxTemp = "\((maindict.value(forKey: "temp_max")) ?? "")"
            aboutModel.RowMinTemp = "\((maindict.value(forKey: "temp_min")) ?? "")"
            aboutModel.RowTemp = "\((maindict.value(forKey: "temp")) ?? "")"
            aboutModel.Rowhumidity = "\((maindict.value(forKey: "humidity")) ?? "")"
            aboutModel.Rowdescription = "\((weatherdict.value(forKey: "description")) ?? "")"
            selectTempModelArray.append(aboutModel)
        }
        
        return selectTempModelArray
    }
    
}

