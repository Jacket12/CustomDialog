//
//  ImgDialog.swift
//  CustomDialog
//
//  Created by JackYe on 2019/6/25.
//  Copyright © 2019 JackYe. All rights reserved.
//

import UIKit

class ImgDialog: BaseDialog {

    /// 内容
    var msg: String? = ""
    
    /// banner图
    var banner: String = ""
    
    // _ title: String = "提示",
    init(_ banner: String, msg: String? = "", _ style: BtnsStyle = .center) {
        super.init()
        
        self.msg = msg
        self.banner = banner
        
        self.btnsStyle = style
        self.closeStyle = .bottom
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        setupViews()
        setupLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func contentView(dialog: UIViewController) -> UIView {
        
        self.containerView.title = self.title
        //self.containerView.titleAttr = self.titleAttr
        self.containerView.msg = self.msg
        self.containerView.banner = self.banner
        
        return self.containerView
    }
    
    override func setupLayout() {
        
        self.contentView.snp.makeConstraints { (make) in
            make.width.equalTo(300 * kScreenWidthScale)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            //make.bottom.equalTo(self.containerView.msgLable.snp.bottom).offset(88)
            make.bottom.equalTo(self.containerView.tipsLable.snp.bottom).offset(84)
        }
    }
    
    private lazy var containerView: ContainerView = {
        let view = ContainerView()
        return view
    }()
    
    override func creatButton(action: DialogAction) {
        super.creatButton(action: action)
        
    }
    
}

/// 容器视图
fileprivate class ContainerView: UIView {
    
    /// 内容
    var title: String? = "" {
        didSet{
            self.titleLable.text = self.title
        }
    }
    
    /// 标题富文本
    var titleAttr: NSMutableAttributedString? {
        didSet{
            if let attrText = self.titleAttr {
                self.titleLable.attributedText = attrText
            }
        }
    }
    
    /// 内容
    var msg: String? = "" {
        didSet{
            guard let text = self.msg else { return }
            
            if text.contains("##") == false {
                self.msgLable.text = text
                //self.msgLable.attributedText(lineSpacing: 4.0)
                self.msgLable.attributedText(html: text, spacing: 4.0)
            }else{
                
                let msgs = text.components(separatedBy: "##")
                if msgs.count >= 2 {
                    self.tipsLable.isHidden = false
                    self.msgLable.text = msgs[0]
                    self.tipsLable.attributedText(html: msgs[1], alignment: .center)
                }else{
                    self.tipsLable.isHidden = true
                }
            }
        }
    }
    
    /// banner图
    var banner: String = "" {
        didSet{
            self.imgView.image = UIImage(named: self.banner)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupLayout()
        self.clipsToBounds = true
        self.layer.cornerRadius = 4
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let size = imgView.image?.size {
//            Logger.log(size.height)
            imgView.snp.updateConstraints({ (make) in
                make.height.equalTo(size.height * kScreenWidthScale)
            })
        }
        
        let top = tipsLable.isHidden == true ? 0 : 12
        tipsLable.snp.updateConstraints { (make) in
            make.top.equalTo(msgLable.snp.bottom).offset(top)
        }
        
        if titleLable.text?.isEmpty == true {
            
            msgLable.snp.remakeConstraints { (make) in
                make.top.equalTo(imgView.snp.bottom).offset(24)
                make.left.equalTo(24)
                make.right.equalTo(-24)
            }
        }
    }
    
    func setupViews() {
        
        addSubview(imgView)
        
        addSubview(titleLable)
        addSubview(msgLable)
        
        addSubview(tipsLable)
    }
    
    func setupLayout() {
        
        imgView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(150 * kScreenWidthScale)
        }
        
        titleLable.snp.makeConstraints { (make) in
            make.top.equalTo(imgView.snp.bottom).offset(24)
            make.left.equalTo(24)
            make.right.equalTo(-24)
        }
        
        msgLable.snp.makeConstraints { (make) in
            make.top.equalTo(titleLable.snp.bottom).offset(10)
            make.left.equalTo(24)
            make.right.equalTo(-24)
        }
        
        let top = tipsLable.isHidden == true ? 0 : 12
        tipsLable.snp.makeConstraints { (make) in
            make.top.equalTo(msgLable.snp.bottom).offset(top)
            make.left.equalTo(24)
            make.right.equalTo(-24)
        }
    }
    
    //MARK: - UI
    var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "banner_user_state")
        return imgView
    }()
    
    lazy var titleLable : UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    /// 内容
    lazy var msgLable : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "你目前的基本信息比较简陋\n完善信息是真诚交友的第一步！"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    /// 注意
    lazy var tipsLable: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.numberOfLines = 0
        label.textAlignment = .center
        //label.text = "注：普通会员和高级会员均为平台的会员"
        label.textColor = UIColor.lightGray
        label.backgroundColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
}

