//
//  UILabel+AttributeText.swift
//  onemate
//
//  Created by DevHank on 2018/7/3.
//  Copyright © 2018年 ai. All rights reserved.
//

import Foundation

extension UILabel {
    
    /// 设置文字的行间距
    ///
    /// - Parameters:
    ///   - text: 传入的文字
    ///   - lineSpacing: 行间距
    /// - Returns: NSMutableAttributedString对象
    public func attributedText(spacing: CGFloat = 4.0) -> Void {
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        style.alignment = self.textAlignment
        style.lineBreakMode = .byTruncatingTail
        
        let attributes = [NSAttributedStringKey.paragraphStyle: style,
                          NSAttributedStringKey.font: self.font,
                          NSAttributedStringKey.foregroundColor: self.textColor] as [NSAttributedStringKey : Any]
        
        let attributedString = NSMutableAttributedString(string: self.text ?? "", attributes: attributes)
        self.attributedText = attributedString
        
    }
    
    /// 行间距、首行缩进
    ///
    /// - Parameters:
    ///   - lineSpacing: 行间距
    ///   - firstHeadIndent: 首页缩进距离
    ///   - font: 字体大小
    func attributedText(lineSpacing: CGFloat = 4.0, _ firstHeadIndent: CGFloat = 0.0) -> Void {
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        style.alignment = self.textAlignment
        style.firstLineHeadIndent = firstHeadIndent
        
        let attributes = [NSAttributedStringKey.paragraphStyle: style,
                          NSAttributedStringKey.font: self.font,
                          NSAttributedStringKey.foregroundColor: self.textColor] as [NSAttributedStringKey : Any]
        
        let attributedString = NSMutableAttributedString(string: self.text ?? "", attributes: attributes)
        self.attributedText = attributedString
    }
    
    
    /// 修改子字符串颜色
    ///
    /// - Parameters:
    ///   - items: 子字符串颜色数组
    ///   - color: 颜色
    func attributedText(items: [String], _ color: UIColor = .red, _ spacing: CGFloat = 4.0, _ itemFont: UIFont = UIFont.systemFont(ofSize: 16)) -> Void {
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        style.alignment = self.textAlignment
        
        let attrs = [NSAttributedStringKey.paragraphStyle: style,
                          NSAttributedStringKey.font: self.font,
                          NSAttributedStringKey.foregroundColor: self.textColor] as [NSAttributedStringKey : Any]
        let attrText = NSMutableAttributedString.init(string: self.text ?? "", attributes: attrs)
        
        let item_attrs = [NSAttributedStringKey.paragraphStyle: style,
                     NSAttributedStringKey.font: itemFont,
                     NSAttributedStringKey.foregroundColor: color] as [NSAttributedStringKey : Any]
        
        
        let text = NSString(string: self.text!)
        
        for item in items {
            let range = text.range(of: item)
            attrText.addAttributes(item_attrs, range: range)
        }
        
        self.attributedText = attrText
    }
    
    /// 通过html设置attributedText
    ///
    /// - Parameters:
    ///   - html: html字符串
    ///   - lineSpacing: 行间距
    public func attributedText(html: String?, spacing: CGFloat = 4.0) -> Void {
        
        guard let string = html else { return }
        
        do {
            let data = string.data(using: .unicode)
            
            let optoins = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
            let attrText = try NSMutableAttributedString(data: data!, options: optoins, documentAttributes: nil)
            
            let range = NSMakeRange(0, attrText.length)
            
            let style = NSMutableParagraphStyle()
            style.lineSpacing = spacing
            style.alignment = self.textAlignment
            
            let attributes = [NSAttributedStringKey.paragraphStyle: style,
                              NSAttributedStringKey.font: self.font,
                              NSAttributedStringKey.foregroundColor: self.textColor] as [NSAttributedStringKey : Any]
            
            attrText.addAttributes(attributes, range: range)
            self.attributedText = attrText
        } catch {
            print(error)
        }
    }
    
}

extension UILabel {
    
    
    /// 根据attributedText获取总行数
    /// 注意： 调用前务必设置attributedText
    /// 参考： https://github.com/kysonyangs/ysbilibili/blob/e3018da134a6c13b5b7af71c3d4d96ee5f826b1a/ysbilibili/Expand/Extensions/UILabel%2BlastLineAdd.swift
    /// - Returns: 总行数
    func totalOfLines() -> Int {
        
        if let attrText = self.attributedText {
            
            /// 创建CTFrame
            let setter: CTFramesetter = CTFramesetterCreateWithAttributedString(attrText)
            let path: CGMutablePath = CGMutablePath()
            path.addRect(CGRect(x: 0, y: 0, width: self.preferredMaxLayoutWidth, height: CGFloat.greatestFiniteMagnitude))
            let frame: CTFrame = CTFramesetterCreateFrame(setter, CFRangeMake(0, 0), path, nil)
            
            /// 获得CTLine数组
            let lines = CTFrameGetLines(frame)
            
            //获得行数
            let totalOfLines = CFArrayGetCount(lines)
            //Logger.log("totalOfLines: \(totalOfLines) :\(attrText.string)")
            return totalOfLines
        }
     
        return 0
    }
    
    
    /// 根据attributedText获取每一行字符串数组
    /// 注意： 调用前务必设置attributedText
    /// - Returns: 每一行字符串数组
    func linesInLable() -> [String] {
        
        var array = [String]()
        
        if let attrText = self.attributedText {
            
            /// 创建CTFrame
            let setter: CTFramesetter = CTFramesetterCreateWithAttributedString(attrText)
            let path: CGMutablePath = CGMutablePath()
            path.addRect(CGRect(x: 0, y: 0, width: self.preferredMaxLayoutWidth, height: CGFloat.greatestFiniteMagnitude))
            let frame: CTFrame = CTFramesetterCreateFrame(setter, CFRangeMake(0, 0), path, nil)
            
            /// 获得CTLine数组
            let lines = CTFrameGetLines(frame) as NSArray
            
            /// 每一行文字
            for line in lines {
                let lineRange = CTLineGetStringRange(line as! CTLine)
                let range: NSRange = NSMakeRange(lineRange.location, lineRange.length)
                let lineString = (attrText.string as NSString).substring(with: range)
                array.append(lineString as String)
            }
        }
        
        return array
    }
    
}


extension String {
    
    /// html标签字符串转NSAttributedString
    ///
    /// - Returns: NSAttributedString
    func attributedHtml() -> NSAttributedString{
        
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        
        do{
            let optoins = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                           NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue] as [NSAttributedString.DocumentReadingOptionKey : Any]
            
            return try NSAttributedString(data: data, options: optoins, documentAttributes: nil)
        }catch{
            return NSAttributedString()
        }
    }
}
