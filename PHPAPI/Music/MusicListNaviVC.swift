//
//  MusicListNaviVC.swift
//  PHPAPI
//
//  Created by WY on 2018/10/18.
//  Copyright © 2018 HHCSZGD. All rights reserved.
//

import UIKit

class MusicListNaviVC: DDBaseNavVC {
    convenience init(){
        let rootVC = MusicListVC()
        
        rootVC.title = "音乐列表"
        //        rootVC.title = DDLanguageManager.text("tabbar_item1_title")
        self.init(rootViewController: rootVC)
        self.navigationBar.shadowImage = UIImage()
        //        self.tabBarItem.image = UIImage(named:"workunselectedicons")
        //        self.tabBarItem.selectedImage = UIImage(named:"workselectedicon")
        
        
        self.tabBarItem.image = UIImage(named:"workunselectediconsTabbar")
        self.tabBarItem.selectedImage = UIImage(named:"workselectediconTabbar")
        DDAccount.share.refreshAccountInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mylog(DDAccount.share.id)
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.childViewControllers.count != 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }

}
