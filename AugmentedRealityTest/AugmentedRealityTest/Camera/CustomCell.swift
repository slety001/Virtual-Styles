//
//  CustomCellCollectionViewCell.swift
//  AugmentedRealityTest
//
//  Created by MacBook on 24.06.18.
//  Copyright © 2018 Anonymer Eintrag. All rights reserved.
//

import UIKit
import ARKit

class CustomCell: UICollectionViewCell {
    @IBOutlet weak var myImage: UIImageView!
    var modelSourcePath : String!
    var selfView : SelfViewController!
    override var isSelected: Bool {
        didSet{
            if self.isSelected
            {
                self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.contentView.backgroundColor = UIColor.green
                getModel()
            }
            else
            {
                self.transform = CGAffineTransform.identity
                self.contentView.backgroundColor = UIColor.gray
                
            }
        }
        
    }

    func getModel(){
        
        if(modelSourcePath.starts(with: "Bubble")){
            
            let alert = UIAlertController(title: "Type in your Statement", message: "", preferredStyle: .alert)
            alert.addTextField{ (textField) in
                textField.text = ""
            }
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let inputText = (alert?.textFields![0].text)! // Force unwrapping because we know it exists.
                
                print("adding Bubble: "+self.modelSourcePath)
                self.selfView.addBubble(image : self.myImage.image!, text : inputText)
            }))
            
            
            selfView.present(alert, animated: true)
            
        }
        else if(modelSourcePath.contains("pet")){
            print("adding Pet: "+modelSourcePath)
            selfView.addPet(path : modelSourcePath)
        }else if(modelSourcePath.starts(with: "remove")){
            selfView.removeModel()
            
        }else{
            print("adding Model: "+modelSourcePath)
            selfView.addModel(path : modelSourcePath)
        }
    }
    
    
}
