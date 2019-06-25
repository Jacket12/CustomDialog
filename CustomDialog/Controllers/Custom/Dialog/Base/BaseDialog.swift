//
//  BaseDialog.swift
//  CustomDialog
//
//  Created by JackYe on 2019/6/25.
//  Copyright © 2019 JackYe. All rights reserved.
//

import UIKit

class BaseDialog: SuperDialog {

    /// 按钮边距
    var btnInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 20, right: 24)
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func creatButton(action: DialogAction) {
        super.creatButton(action: action)
        
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitle(action.title, for: .normal)
        btn.setTitleColor(action.titleColor, for: .normal)
        btn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        buttons.append(btn)
        
        if action.title.isEmpty == true {
            let image = action.image.isEmpty == true ? "cancel_white" : action.image
            btn.setImage(UIImage(named: image), for: .normal)
            self.view.addSubview(btn)
        }else{
            contentView.addSubview(btn)
        }
    }
    
    override func setupBtnsLayout() {
        super.setupBtnsLayout()
        
        let count = buttons.count
        var suffixBtn: UIButton? = nil
        for (index, button) in buttons.enumerated().reversed() {
            button.tag = index
            let action = actions[index]
            if action.title.isEmpty == true { // 取消按钮
                button.snp.makeConstraints({ (make) in
                    if closeStyle == .right {
                        make.top.equalTo(contentView.snp.top)
                        make.right.equalTo(contentView.snp.right)
                        make.width.height.equalTo(36)
                    }else{
                        make.top.equalTo(contentView.snp.bottom).offset(50)
                        make.centerX.equalTo(view.snp.centerX)
                        make.width.height.equalTo(36)
                    }
                })
            }else{
                
                if self.btnsStyle == .center {
                    button.snp.makeConstraints({ (make) in
                        make.height.equalTo(action.height)
                        make.left.equalTo(contentView.snp.left).offset(btnInset.left)
                        make.right.equalTo(contentView.snp.right).offset(-btnInset.right)
                        make.bottom.equalTo(contentView.snp.bottom).offset(-btnInset.bottom)
                    })
                    
                    button.clipsToBounds = true
                    button.layer.cornerRadius = action.cornerRadius
//                    button.setBackgroundImage(UIImage(gradientColors: [ColorTheme, ColorOrange]), for: .normal)
                    button.backgroundColor = UIColor.gray
                }else if self.btnsStyle == .horizontal {
                    
                    button.snp.makeConstraints({ (make) in
                        make.height.equalTo(action.height)
                        if let btn = suffixBtn {
                            make.left.equalTo(24)
                            make.right.equalTo(btn.snp.left).offset(-12)
                            make.width.equalTo(btn.snp.width)
                        } else {
                            make.right.equalTo(contentView.snp.right).offset(-24)
                        }
                        //make.bottom.equalTo(contentView.snp.bottom).offset(-32)
                        make.bottom.equalTo(contentView.snp.bottom).offset(-20)
                    })
                    
                    button.clipsToBounds = true
                    button.layer.cornerRadius = action.cornerRadius
                    if index == 1 {
//                        button.setBackgroundImage(UIImage(gradientColors: [ColorTheme, ColorOrange]), for: .normal)
                         button.backgroundColor = UIColor.gray
                    }else{
                        button.layer.borderWidth = 0.5
                        button.layer.borderColor = UIColor(named: "#ededed")?.cgColor
                        button.backgroundColor = .white
                    }
                    suffixBtn = button
                    
                }else{
                    
                    button.contentHorizontalAlignment = .right
                    button.titleLabel?.adjustsFontSizeToFitWidth = true //自动调整文字宽度
                    if (index + 1 == count) {
                        button.setTitleColor(UIColor.black, for: .normal)
                        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
                    } else {
                        button.setTitleColor(UIColor.black, for: .normal)
                        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
                    }
                    
                    button.snp.makeConstraints { (make) in
                        if let btn = suffixBtn {
                            make.right.equalTo(btn.snp.left)
                        } else {
                            make.right.equalTo(contentView.snp.right).offset(-24)
                        }
                        make.height.equalTo(30)
                        make.bottom.equalTo(contentView.snp.bottom).offset(-12)
                    }
                    suffixBtn = button
                }
            }
        }
    }
    
    deinit {
        
        print("销毁")
    }
}
