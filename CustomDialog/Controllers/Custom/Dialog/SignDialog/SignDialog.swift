//
//  SignDialog.swift
//  CustomDialog
//
//  Created by JackYe on 2019/6/25.
//  Copyright © 2019 JackYe. All rights reserved.
//

import UIKit

class SignDialog: BaseDialog {

    /// 内容
    var msg: String? = ""
    
    /// banner图
    var banner: String = ""
    
    init(title: String = "每日签到", banner: String, msg: String? = "") {
        super.init()
        
        self.msg = msg
        self.title = title
        self.banner = banner
        
        self.btnsStyle = .center
        self.closeStyle = .right
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
        self.containerView.msg = self.msg
        self.containerView.banner = self.banner
        
        return self.containerView
    }
    
    override func setupLayout() {
        
        self.contentView.snp.makeConstraints { (make) in
            make.width.equalTo(280 * kScreenWidthScale)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.bottom.equalTo(self.containerView.msgLable.snp.bottom).offset(80)
        }
    }
    
    private lazy var containerView: ContainerView = {
        let view = ContainerView()
        return view
    }()
    
    override func creatButton(action: DialogAction) {
        super.creatButton(action: action)
        
    }
    
    override func creatButtons() {
        super.creatButtons()
        
        for (i, btn) in self.buttons.enumerated() {
            if actions[i].title.isEmpty == true {
                btn.setImage(UIImage(named: "sign_close"), for: .normal)
            }
        }
    }
    
    override func setupBtnsLayout() {
        super.setupBtnsLayout()
        
        for (i, btn) in self.buttons.enumerated() {
            if actions[i].title.isEmpty == false {
//                btn.setBackgroundImage(UIImage(gradientColors: [UIColor(named: "#fd854f"), UIColor(named:"#fd755c")]), for: .normal)
                btn.backgroundColor = .gray
            }
        }
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
    
    /// 内容
    var msg: String? = "" {
        didSet{
            guard let text = self.msg else { return }
            
            if text.contains("##") == false {
                self.msgLable.text = text
                self.msgLable.attributedText(lineSpacing: 4.0)
            }else{
                
                let msgs = text.components(separatedBy: "##")
                if msgs.count >= 2 {
                    //self.tipsLable.isHidden = false
                    self.msgLable.text = msgs[0]
                    //self.tipsLable.attributedText(html: msgs[1], alignment: .center)
                }else{
                    //self.tipsLable.isHidden = true
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
    }
    
    func setupViews() {
        
        addSubview(imgView)
        
        addSubview(titleLable)
        addSubview(msgLable)
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
            make.top.equalTo(titleLable.snp.bottom).offset(16)
            make.left.equalTo(24)
            make.right.equalTo(-24)
        }
    }
    
    //MARK: - UI
    var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "sign_coins_popup")
        return imgView
    }()
    
    lazy var titleLable : UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    /// 内容
    lazy var msgLable : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "前往“任务中心“签到即可领取"
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
}
