//
//  TextViewViewController.swift
//  CoreDataDocuments
//
//  Created by Liam Flaherty on 9/21/18.
//  Copyright © 2018 Liam Flaherty. All rights reserved.
//

import UIKit
import CoreData

class TextViewViewController: UIViewController {
    var URLcontents : URL?
    
    @IBOutlet weak var TitleBox: UITextField!
    
    @IBOutlet weak var TextBox: UITextView!
    
    var document:CoreData?
    
    @IBAction func SaveDocument(_ sender: Any) {
        guard let name = TitleBox.text else {
            alertNotifyUser(message: "Document not saved.\nThe name is not accessible.")
            return
        }
        
        let documentName = name.trimmingCharacters(in: .whitespaces)
        if (documentName == "") {
            alertNotifyUser(message: "Document not saved.\nA name is required.")
            return
        }
        
        let content = TextBox.text
        
        if document == nil {
            
            document = CoreData(name: documentName, content: content)
        } else {
            document?.update(name: documentName, content: content)
        }
        
        if let document = document {
            do {
                let managedContext = document.managedObjectContext
                try managedContext?.save()
            } catch {
                alertNotifyUser(message: "The document context could not be saved.")
            }
        } else {
            alertNotifyUser(message: "The document could not be created.")
        }
        
        navigationController?.popViewController(animated: true)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Documents"
        
        if let document = document {
            let name = document.name
            TitleBox.text = name
            TextBox.text = document.content
            title = name
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alertNotifyUser(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }

}
