//
//  CustomDialogController.swift
//  CustomDialog
//
//  Created by JackYe on 2019/6/25.
//  Copyright © 2019 JackYe. All rights reserved.
//

import UIKit

class CustomDialogController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "自定义弹框"
        
        setupViews()
        setupLayout()
        
        self.button.addTarget(self, action: #selector(click(_ :)), for: .touchUpInside)
        self.button1.addTarget(self, action: #selector(click1(_ :)), for: .touchUpInside)
        self.button2.addTarget(self, action: #selector(click2(_ :)), for: .touchUpInside)
    }
    
    
    @objc func click(_ sender: UIButton) {
        
        let dialog = MsgDialog.init(title: "提示", "你确定退出登录吗？")
        let closeAction = DialogAction.init(title: "取消")
        let sureAction = DialogAction.init(title: "确定"){ (action) in
           
        }
        dialog.addButtons([closeAction, sureAction])
        self.present(dialog, animated: true, completion: nil)
    }
    
    @objc func click1(_ sender: UIButton) {
        

        let dialog = ImgDialog.init("sad_popup", msg: "图片弹框图片弹框图片弹框图片弹框图片弹框图片弹框图片弹框图片弹框图片弹框图片弹框图片弹框图片弹框")
        let closeAction = DialogAction(title: "提示")
        let sureAction = DialogAction(title: "了解一下") { (action) in
        }
        dialog.addButtons([closeAction, sureAction])
        self.present(dialog, animated: true, completion: nil)
    }
    
    @objc func click2(_ sender: UIButton) {
        
        
        /// 每日签到
        let dialog = SignDialog.init(title: "提示", banner: "sign_coins_popup@2x.jpg", msg: "前往“任务中心“签到即可领取")
        dialog.tapOutsideDismiss = false
        let colseAction = DialogAction.init(title: "取消")
        let sureAction = DialogAction(title: "签到", titleColor: .white) { (action) in
           
        }
        dialog.addButtons([colseAction, sureAction])
        self.present(dialog, animated: true, completion: nil)
    }
    
    func setupViews() {
        
        self.view.addSubview(button)
        self.view.addSubview(button1)
        self.view.addSubview(button2)
    }
    
    func setupLayout() {
        
        button.snp.makeConstraints { (make) in
            
            make.top.equalTo(200)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(30)
        }
        
        button1.snp.makeConstraints { (make) in
            
            make.top.equalTo(button.snp.bottom).offset(60)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(30)
        }
        
        button2.snp.makeConstraints { (make) in
            
            make.top.equalTo(button1.snp.bottom).offset(60)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(30)
        }
    }
    
    var button: UIButton = {
        
        let btn = UIButton()
        btn.setTitle("MsgDialog", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.contentHorizontalAlignment = .center
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor.black.cgColor
        return btn
    }()
    
    var button1: UIButton = {
        
        let btn = UIButton()
        btn.setTitle("ImgDialog", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.contentHorizontalAlignment = .center
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor.black.cgColor
        return btn
    }()
    
    var button2: UIButton = {
        
        let btn = UIButton()
        btn.setTitle("SignDialog", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.contentHorizontalAlignment = .center
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor.black.cgColor
        return btn
    }()
}

