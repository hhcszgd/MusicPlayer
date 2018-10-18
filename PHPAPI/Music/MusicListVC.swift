//
//  MusicListVC.swift
//  PHPAPI
//
//  Created by WY on 2018/10/18.
//  Copyright © 2018 HHCSZGD. All rights reserved.
//

import UIKit

class MusicListVC: DDNormalVC {
    var musicModels : [MusicModel]?
    var pdfModels : [MusicModel]?
    let tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "音乐列表"
        self.configTableView()
        
        musicModels = self.gotResourceInSubBundle()?.map({ (url ) -> MusicModel in
            let model = MusicModel()
            model.url = url
            model.name = url.lastPathComponent + ".\(url.pathExtension)"
            return model
        })
        musicModels?.sort(by: { (modelLeft, modelRight) -> Bool in
            modelLeft.name < modelRight.name
        })
        self.pdfModels = self.gotPDFInSubBundle()
        self.tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func gotResourceInSubBundle() -> [URL]? {
//        let bundle : Bundle = Bundle(for: AHPAPI.self)       //refreshBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[MJRefreshComponent class]] pathForResource:@"MJRefresh" ofType:@"bundle"]];
        
        let bundle = Bundle.main
        guard let subBundlePath = bundle.path(forResource: "Music", ofType: "bundle") else {return nil}
        guard let subBundle = Bundle(path: subBundlePath) else {return nil  }
        return subBundle.urls(forResourcesWithExtension: "mp3", subdirectory: nil)
       
        //    guard let subBundlePath = Bundle.main.path(forResource: "Resource", ofType: "bundle") else {return nil}
        //    guard let subBundle = Bundle(path: subBundlePath) else {return nil  }
        //    if let tempDirectory = directory {
        //        guard let itemPath = subBundle.path(forResource: name, ofType: type, inDirectory: tempDirectory) else {return nil}
        //        return itemPath
        //    }else{
        //        guard let  itemPath = subBundle.path(forResource: name, ofType: type) else {  return nil  }
        //        return itemPath
        //    }
    }
    func gotPDFInSubBundle() -> [MusicModel]? {
        //        let bundle : Bundle = Bundle(for: AHPAPI.self)       //refreshBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[MJRefreshComponent class]] pathForResource:@"MJRefresh" ofType:@"bundle"]];
        
        let bundle = Bundle.main
        guard let subBundlePath = bundle.path(forResource: "Music", ofType: "bundle") else {return nil}
        guard let subBundle = Bundle(path: subBundlePath) else {return nil  }
        var pdfs = subBundle.urls(forResourcesWithExtension: "pdf", subdirectory: nil)
        var temp  = pdfs?.map({ (url ) -> MusicModel in
            let model = MusicModel()
            model.url = url
            model.name = url.lastPathComponent + ".\(url.pathExtension)"
            return model
        })
        temp?.sort(by: { (modelLeft, modelRight) -> Bool in
            modelLeft.name < modelRight.name
        })
        
        return temp
        
        
        //    guard let subBundlePath = Bundle.main.path(forResource: "Resource", ofType: "bundle") else {return nil}
        //    guard let subBundle = Bundle(path: subBundlePath) else {return nil  }
        //    if let tempDirectory = directory {
        //        guard let itemPath = subBundle.path(forResource: name, ofType: type, inDirectory: tempDirectory) else {return nil}
        //        return itemPath
        //    }else{
        //        guard let  itemPath = subBundle.path(forResource: name, ofType: type) else {  return nil  }
        //        return itemPath
        //    }
    }
}


extension MusicListVC  : UITableViewDelegate , UITableViewDataSource{
    
    func configTableView()  {
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = self.view.bounds
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let name = musicModels?[indexPath.row].name {
//            var  para  = [String: Any]()
//            para["currentSong"] = indexPath.row
//            para["songsArr"] = musicModels
//            para["pdfs"] = self.pdfModels
        let vc = PlayVC()
        vc.musicModel = musicModels
        vc.pdfModels = pdfModels
        vc.currentIndex = indexPath.row
        vc.userInfo = pdfModels?[indexPath.row].url?.absoluteString
        self.navigationController?.pushViewController(vc , animated: true )
//            self.pushVC(vcIdentifier: "PlayVC", userInfo:para)
//        }
       
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.musicModels?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        if let tempCell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier"){
            cell = tempCell
        }else{
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "reuseIdentifier")
        }
        //        cell.backgroundColor = UIColor.init(red:CGFloat (arc4random() % 256) / 256, green: CGFloat((arc4random() % 256) / 256), blue:CGFloat((arc4random() % 256) / 256), alpha: 1)
        
        cell.textLabel?.text = self.musicModels?[indexPath.row].name
        return cell
    }
}
