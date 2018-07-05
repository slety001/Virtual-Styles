//
//  FileSharingViewController.swift
//  AugmentedRealityTest
//
//  Created by MacBook on 04.07.18.
//  Copyright © 2018 Anonymer Eintrag. All rights reserved.
//

import UIKit

class FileSharingViewController: UIViewController {
    @IBOutlet weak var fileTableView: UITableView!
    var documentsDirectory : NSString?
    var appDelegate : AppDelegate?
    var arrFiles : NSMutableArray?
    var selectedFile : NSString?
    var selectedRow : NSInteger?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        self.copySampleFilesToDocDirIfNeeded()
        arrFiles = self.getAllDocDirFiles() as? NSMutableArray
        fileTableView.delegate = self
        fileTableView.dataSource = self
        fileTableView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getAllDocDirFiles()-> NSArray{
        var allFiles : NSArray
        let fileManager : FileManager = FileManager.default
        do {
            try  allFiles = fileManager.contentsOfDirectory(atPath: documentsDirectory! as String) as NSArray
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            
        }
        return allFiles
    }
    
    func copySampleFilesToDocDirIfNeeded(){
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        documentsDirectory = paths[0] as NSString
        let file1Path = documentsDirectory?.appendingPathComponent("sample_file1.txt")
        let file2Path = documentsDirectory?.appendingPathComponent("sample_file2.txt")
        
        let fileManager : FileManager = FileManager.default
        
        if(!fileManager.fileExists(atPath: file1Path!)||fileManager.fileExists(atPath: file2Path!)){
            do {
                try fileManager.copyItem(atPath: Bundle.main.path(forResource: "sample_file1", ofType: "txt")!, toPath: file1Path!)
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            do {
                try fileManager.copyItem(atPath: Bundle.main.path(forResource: "sample_file2", ofType: "txt")!, toPath: file2Path!)
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            
        }
        
        
        
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
extension FileSharingViewController: UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //
        return (arrFiles?.count)!
    }
    private func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> Float {
        //
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //
        var cell : UITableViewCell?
        if (cell == nil){
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "CellIdentifier")
            cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        cell?.textLabel?.text = arrFiles?.object(at: indexPath.row) as? String
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedFile = arrFiles?.object(at: indexPath.row) as? NSString
        
        //let confirmSending = UIActionSheet.init(title: selectedFile, delegate: self, cancelButtonTitle: nil, destructiveButtonTitle: nil, otherButtonTitle: nil)
        let alertController = UIAlertController(title: nil, message: "myMessage", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel){ (action) in
            alertController.removeFromParentViewController()
        }
        alertController.addAction(cancelAction)
        
        
        let peers = appDelegate?.mcManager?.session?.connectedPeers
        var index : Int = 0
        for peer in peers!{
            
            let peerAction = UIAlertAction(title: peer.displayName, style: .default){ (action) in
                if(index != peers?.count){
                    let filePath = self.documentsDirectory?.appending(self.selectedFile as! String)
                    let modifiedName = (self.appDelegate?.mcManager?.peerID?.displayName)! + "_" + String(self.selectedFile!)
                    let resourceURL = NSURL.fileURL(withPath: filePath!)
                    
                    DispatchQueue.main.async {
                        let progress : Progress = (self.appDelegate?.mcManager?.session?.sendResource(at: resourceURL, withName: modifiedName, toPeer: peer, withCompletionHandler: nil))!
                        
                    }
                    
                }
            }
            alertController.addAction(peerAction)
            index += 1
        }
        self.present(alertController, animated: true, completion: nil)
        selectedFile = arrFiles?.object(at: indexPath.row) as? NSString
        selectedRow = indexPath.row
        
    }
    
}
