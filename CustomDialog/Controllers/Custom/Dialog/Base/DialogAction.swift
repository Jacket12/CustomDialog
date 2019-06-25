//
//  DialogAction.swift
//  yiyue
//
//  Created by DevHank on 2018/3/12.
//  Copyright © 2018年 ai. All rights reserved.
//

import Foundation

public final class DialogAction {
    
    /// 文字
    public let title: String
    
    /// 图片
    public let image: String
    
    /// 文字颜色
    public let titleColor: UIColor
    
    /// 圆角半径
    public var cornerRadius: CGFloat = 4.0
    
    /// 高度
    public var height: CGFloat = 40.0
    
    /// 回调
    public let handler: ((DialogAction) -> Void)?
    
    
    public init(title: String, image: String = "", titleColor: UIColor = .black, _ radius: CGFloat = 4.0, _ height: CGFloat = 40.0, handler: ((DialogAction) -> Void)? = nil) {
        
        self.title      = title
        self.image      = image
        self.titleColor = titleColor
        self.cornerRadius = radius
        self.height     = height
        self.handler    = handler
    }
}
