//
//  DDPeiXunVC.swift
//  Project
//
//  Created by WY on 2018/6/4.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import AVKit
class DDVideoListVC: DDNormalVC {

    let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
    //视频比例是960 * 540
    let tableHeader = DDPeixunHeader(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH , height:SCREENWIDTH  * 540 / 960))
    var apiModel = ApiModel<DDPeixunDataModel>(){
        didSet{

        }
    }
    var statusIsHidden = false
    
    var player : DDPlayerView?
    var selectedModel : DDPeixunSourceModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "培训"
        configTableView()
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.addNotificationObserver()
    }
    
    func addNotificationObserver() {
        NotificationCenter.default.addObserver(self , selector: #selector(hideStatusBar), name: NSNotification.Name(rawValue: "PeiXunMovieFullScreen"), object: nil )
        NotificationCenter.default.addObserver(self , selector: #selector(showStatusBar), name: NSNotification.Name(rawValue: "PeiXunMovieSmallScreen"), object: nil )
    }
    @objc func hideStatusBar() {
        statusIsHidden = true
        self.setNeedsStatusBarAppearanceUpdate()
    }
    @objc func showStatusBar() {
        statusIsHidden = false
        self.setNeedsStatusBarAppearanceUpdate()
    }
    func removeNotificationObserver() {
        NotificationCenter.default.removeObserver(self )
    }
    func configTableView() {
        tableView.frame = CGRect(x:0 , y : DDNavigationBarHeight , width : self.view.bounds.width , height : self.view.bounds.height - DDNavigationBarHeight - DDTabBarHeight)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableHeaderView = self.tableHeader
//        DDPlayerView.init(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH , height:SCREENWIDTH * 0.7), superView: self.tableHeader, urlStr: "http://1252719796.vod2.myqcloud.com/e7d81610vodgzp1252719796/27444c997447398156401949676/QHAfaCW5HiEA.mp4")
        requestApi()
    }
    func requestApi()  {
//        DDRequestManager.share.getPeixunInfo(print: true )?.responseJSON(completionHandler: { (response) in
//            mylog(response.result)
//            if let apiModel = DDJsonCode.decodeAlamofireResponse(ApiModel<DDPeixunDataModel>.self, from: response){
//                dump(apiModel)
//                self.apiModel = apiModel
//                self.tableHeader.imageView.setImageUrl(url: self.apiModel.data?.top_img)
//                self.tableView.reloadData()
//            }
//        })
    }
    
    override var prefersStatusBarHidden: Bool{
        return statusIsHidden //return make for hidding statusBar , and navigationBar become shortter than normal
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
//        super.preferredStatusBarUpdateAnimation
        return UIStatusBarAnimation.fade

    }
    
    
    deinit {
        mylog("is pei xun vc desdroyed ? ")
        self.player?.destroy()
        self.removeNotificationObserver()
    }
}

extension DDVideoListVC : UITableViewDelegate , UITableViewDataSource {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        type    string    1图文2视频
        
        if let model = self.apiModel.data?.items?[indexPath.row]{
            if model.type ?? "" == "1"{
                toWebView(ID:model.id ?? "")
            }else if model.type ?? "" == "2"{
                selectedModel?.isSelected = false
                model.isSelected = true
                selectedModel = model
                self.tableView.reloadData()
                if let player = self.player {
                    let url = model.content ?? ""
                    let currentUrl = self.player?.currentUrl ?? ""
                    if url != currentUrl {
                        player.replaceCurrentMovieItemWith(urlStr: url , placeholderImgUrlStr:model.thumbnail )
                        self.player?.bottomBar.perfomrTap()
                    }
                    player.playerLayer?.player?.play()
                }else{
                    self.player =  DDPlayerView.init(frame: CGRect(x: 0, y: 0, width: self.tableHeader.bounds.width , height:self.tableHeader.bounds.height), superView: self.tableHeader, urlStr: model.content ?? "")
                    self.player?.playerLayer?.player?.play()
                }
            }
        }
    }
    @objc func toWebView(ID:String) {
//        let url = DomainType.a.rawValue +  "business-trainning?id=\(ID)"
//        self.pushVC(vcIdentifier: "GDBaseWebVC", userInfo: url)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apiModel.data?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.apiModel.data?.items?[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DDPeixunCell") as? DDPeixunCell{
            cell.model = model
//            cell.keyWorld = self.searchBox.text
            return cell
        }else{
            
            let cell = DDPeixunCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDPeixunCell")
//            cell.keyWorld = self.searchBox.text
            cell.model = model
            return cell
        }
    }
}
import SDWebImage
extension DDVideoListVC{
    class DDPeixunDataModel : NSObject , Codable{
        var items : [DDPeixunSourceModel]?
        var top_img : String?
    }
    class DDPeixunSourceSuperModel : NSObject{
        var isSelected = false
    }
    class DDPeixunSourceModel : DDPeixunSourceSuperModel , Codable{
        var content : String?
        var name : String?
        var thumbnail : String?
        var type : String?
        var id : String?
    }
    class DDPeixunCell : UITableViewCell {
        let icon  = UIImageView()
        let title = UILabel()
        let playIdentify = UIView()
        let bottomLine = UIView()
        
        var model : DDPeixunSourceModel? {
            didSet{
                 title.text = model?.name
                // 1图文2视频
                if model?.type ?? "" == "2"{//视频
                    if model?.isSelected ?? false {
                        icon.image = UIImage(named:"videoplayback")
                        playIdentify.backgroundColor = UIColor.orange
                    }else{
                        icon.image = UIImage(named:"videoisnotplayed")
                        playIdentify.backgroundColor = UIColor.clear
                    }
                }else if model?.type ?? "" == "1"{//网页
                    icon.image = UIImage(named:"image&text")
                }
            }
        }
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.selectionStyle = .none
            self.contentView.addSubview(icon)
            self.contentView.addSubview(title)
            self.contentView.addSubview(playIdentify)
            self.contentView.addSubview(bottomLine)
            title.textColor = UIColor.DDTitleColor
            title.font = GDFont.systemFont(ofSize: 17)
            bottomLine.backgroundColor = UIColor.DDLightGray
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            let margin : CGFloat = 10
            let bottomLineH : CGFloat = 2
            let iconTopMargin : CGFloat = 20
            let iconWH = self.bounds.height - iconTopMargin * 2 - bottomLineH
            icon.frame = CGRect(x: margin , y: iconTopMargin , width:iconWH, height:iconWH )
            title.ddSizeToFit()
            title.frame = CGRect(x: icon.frame.maxX + margin, y: 0 , width: self.frame.width - margin - icon.frame.maxX - margin , height: self.bounds.height)
            let playIdentifyWH : CGFloat = 14
            let playIdentifyY : CGFloat = (self.bounds.height - playIdentifyWH ) / 2
            playIdentify.frame = CGRect(x: self.bounds.width - (playIdentifyWH + margin), y: playIdentifyY , width: playIdentifyWH , height:playIdentifyWH)
            playIdentify.layer.cornerRadius = playIdentifyWH/2
            playIdentify.layer.masksToBounds = true
            bottomLine.frame = CGRect(x: 0, y: self.bounds.height - bottomLineH, width: self.bounds.width, height: bottomLineH)
          
            
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    
}
class DDPeixunHeader : UIView{
    let imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
