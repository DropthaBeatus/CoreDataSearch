//
//  CoreData+CoreDataClass.swift
//  CoreDataDocuments
//
//  Created by Liam Flaherty on 10/4/18.
//  Copyright © 2018 Liam Flaherty. All rights reserved.
//
//

import UIKit
import CoreData

@objc(CoreData)
public class CoreData: NSManagedObject {
    
        var modifiedDate: Date? {
            get {
                return dateModCD as Date?
            }
            set {
                dateModCD = newValue as NSDate?
            }
        }
        
        convenience init?(name: String?, content: String?) {
            let appDelegate = UIApplication.shared.delegate as? AppDelegate  //UIKit is needed to access UIApplication
            guard let managedContext = appDelegate?.persistentContainer.viewContext,
                let name = name, name != "" else {
                    return nil
            }
            self.init(entity: CoreData.entity(), insertInto: managedContext)
            self.name = name
            self.content = content
            if let size = content?.count {
                self.fileSizeCD = Int32(size)
            } else {
                self.fileSizeCD = 0
            }
            
            self.modifiedDate = Date(timeIntervalSinceNow: 0)
        }
        
        func update(name: String, content: String?) {
            self.name = name
            self.content = content
            if let size = content?.count {
                self.fileSizeCD = Int32(size)
            } else {
                self.fileSizeCD = 0
            }
            
            self.modifiedDate = Date(timeIntervalSinceNow: 0)
        }
}
