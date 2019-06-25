//
//  MsgDialog.swift
//  CustomDialog
//
//  Created by JackYe on 2019/6/25.
//  Copyright © 2019 JackYe. All rights reserved.
//

import UIKit

class MsgDialog: BaseDialog {

    /// 自定义footer视图
    var footerView: UIView?
    
    /// 点击事件监听
    var onTapListenBlock: OnListenBlock? {
        didSet{
            self.containerView.tipsBtn.isHidden = false
        }
    }
    
    init(title: String = "提示", _ msg: String? = "", _ style: BtnsStyle = .default, _ footer: UIView? = nil) {
        super.init()
        
        self.title = title
        self.msg = msg
        self.btnsStyle = style
        self.footerView = footer
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.btnsStyle == .center || self.btnsStyle == .horizontal {
            self.containerView.alignment = .center
        }
        
        self.containerView.tipsBtn.addTarget(self, action: #selector(tapAction(_:)), for: .touchUpInside)
    }
    
    @objc func tapAction(_ sender: UIButton) {
        
        self.onTapListenBlock?()
        self._dismiss()
    }
    
    override func contentView(dialog: UIViewController) -> UIView {
        
        self.containerView.titleLable.text = self.title
        return self.containerView
    }
    
    override func setupViews() {
        super.setupViews()
        
        switch self.btnsStyle {
        case .center:
            self.btnInset = UIEdgeInsets(top: 0, left: 24, bottom: 20, right: 24)
            break
        case .horizontal:
            self.btnInset = UIEdgeInsets(top: 0, left: 24, bottom: 32, right: 24)
            break
        default:
            break
        }
        
        // 添加自定义footer视图
        if let customView = self.footerView {
            self.btnInset = UIEdgeInsets(top: 0, left: 24, bottom: customView.frame.height, right: 24)
            self.containerView.addSubview(customView)
        }
    }
    
    override func setupLayout() {
        
        if self.btnsStyle == .default {
            
            self.contentView.snp.makeConstraints { (make) in
                make.width.equalTo(310 * kScreenWidthScale)
                make.bottom.equalTo(self.containerView.tipsLable.snp.bottom).offset(70)
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
            }
        }else{
            
            // 自定义footer视图
            var footerH = self.btnInset.bottom
            if let customView = self.footerView {
                let h = customView.frame.height
                footerH = h
                customView.snp.makeConstraints { (make) in
                    make.left.equalToSuperview()
                    make.right.equalToSuperview()
                    make.height.equalTo(h)
                    make.bottom.equalToSuperview()
                }
            }
            
            let bottom = footerH + 28.0 + 40.0
            self.contentView.snp.makeConstraints { (make) in
                make.width.equalTo(310 * kScreenWidthScale)
                make.bottom.equalTo(self.containerView.tipsLable.snp.bottom).offset(bottom)
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
            }
        }
    }
    
    override func setupBtnsLayout() {
        super.setupBtnsLayout()
        
    }
    
    private lazy var containerView: ContainerView = {
        let view = ContainerView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        view.backgroundColor = UIColor.white
        return view
    }()
    
    //MARK: - 属性
    var _msg: String?
    var msg: String? {
        get{
            return self._msg
        }
        set{
            self._msg = newValue
            guard let text = self._msg else { return }
            
            if text.contains("##") == false {
                
                self.containerView.msg = text
                //self.containerView.msgLable.attributedText(lineSpacing: 4.0)
                self.containerView.msgLable.attributedText(html: text, spacing: 4.0)
                //self.containerView.attrText = self.msgAttrText
            }else{
                
                let msgs = text.components(separatedBy: "##")
                if msgs.count >= 2 {
                    self.containerView.msg = msgs[0]
                    self.containerView.tipsLable.text = msgs[1]
                    self.containerView.tipsLable.attributedText(html: msgs[1])
                }
            }
            self.containerView.updateLayout()
        }
    }
    
    deinit {
       
        print("销毁")
    }
}

/// 容器视图
fileprivate class ContainerView: UIView {
    
    var alignment :NSTextAlignment = .left {
        didSet{
            self.titleLable.textAlignment = self.alignment
            self.titleLable.font = self.alignment == .center ? UIFont.boldSystemFont(ofSize: 20) : UIFont.boldSystemFont(ofSize: 16)
        }
    }
    
    /// 内容
    var msg: String? = "" {
        didSet{
            self.msgLable.text = self.msg
            self.msgLable.attributedText(lineSpacing: 4.0)
        }
    }
    
    /// 富文本内容
    var attrText: NSMutableAttributedString? {
        didSet{
            if let attrText = self.attrText {
                self.msgLable.attributedText = attrText
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupLayout()
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        addSubview(titleLable)
        addSubview(msgLable)
        addSubview(tipsLable)
        
        addSubview(tipsBtn)
    }
    
    func setupLayout() {
        
        titleLable.snp.makeConstraints { (make) in
            make.top.equalTo(28)
            make.left.equalTo(24)
            make.right.equalTo(-24)
        }
        
        msgLable.snp.makeConstraints { (make) in
            make.top.equalTo(titleLable.snp.bottom).offset(16)
            make.left.equalTo(24)
            make.right.equalTo(-24)
        }
        
        let top = tipsLable.isHidden == true ? 0 : 16
        tipsLable.snp.makeConstraints { (make) in
            make.top.equalTo(msgLable.snp.bottom).offset(top)
            make.left.equalTo(24)
            make.right.equalTo(-24)
            make.height.lessThanOrEqualTo(CGFloat.leastNormalMagnitude)
        }
        
        tipsBtn.snp.makeConstraints { (make) in
            make.edges.equalTo(tipsLable)
        }
    }
    
    func updateLayout() {
        
        if self.tipsLable.text?.isEmpty == true {
            self.tipsLable.isHidden = true
        }else{
            self.tipsLable.isHidden = false
        }
        
        let top = tipsLable.isHidden == true ? 0 : 16
        let height = tipsLable.isHidden == true ? CGFloat.leastNormalMagnitude : CGFloat.greatestFiniteMagnitude
        tipsLable.snp.updateConstraints({ (make) in
            make.top.equalTo(msgLable.snp.bottom).offset(top)
            make.height.lessThanOrEqualTo(height)
        })
    }
    
    //MARK: - UI
    /// 标题
    lazy var titleLable: UILabel = {
        let label = UILabel()
        label.text = "提示"
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    /// 内容
    lazy var msgLable : UILabel = {
        let label = UILabel()
        label.text = "内容"
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    /// 附加说明
    lazy var tipsLable : UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = ""
        label.numberOfLines = 0
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 12)
        //label.text = "注：普通会员和高级会员均为平台的会员"
        return label
    }()
    
    /// 跳转链接
    lazy var tipsBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.isHidden = true
        return btn
    }()
    
}


/// 自定义底部文案视图
class MsgDialogFooterView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        addSubview(checkLabel)
    }
    
    func setupLayout() {
        
        checkLabel.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.height.equalTo(12)
            make.bottom.equalTo(-20)
        }
    }
    
    /// 不再提醒
    lazy var checkLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "*下次不再提醒了"
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
}
