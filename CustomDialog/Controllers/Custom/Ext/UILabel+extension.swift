//
//  UILabel+extension.swift
//  yiyue
//
//  Created by DevHank on 2018/1/15.
//  Copyright © 2018年 YiBan. All rights reserved.
//

import Foundation

extension UILabel {
    
    /// 首行缩进
    ///
    /// - Parameters:
    ///   - firstLineHeadIndent: 首页缩进距离
    ///   - lineSpacing: 行间距
    ///   - font: 字体大小
    func attributedText(firstLineHeadIndent: CGFloat, lineSpacing: CGFloat = 4.0) -> Void {
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        style.alignment = self.textAlignment
        style.firstLineHeadIndent = firstLineHeadIndent
        
        let attributes = [NSAttributedStringKey.paragraphStyle: style, NSAttributedStringKey.font: self.font] as [NSAttributedStringKey : Any]
        
        let attributedString = NSMutableAttributedString(string: self.text!, attributes: attributes)
        self.attributedText = attributedString
    }
    
    
    /// 设置文字的行间距
    ///
    /// - Parameters:
    ///   - text: 传入的文字
    ///   - lineSpacing: 行间距
    /// - Returns: NSMutableAttributedString对象
    public func attributedText(lineSpacing: CGFloat = 4.0) -> Void {
        
        let style = NSMutableParagraphStyle()
        style.paragraphSpacing = 6.0
        style.lineSpacing = lineSpacing
        style.alignment = self.textAlignment
        
        let attributes = [NSAttributedStringKey.paragraphStyle: style,
                          NSAttributedStringKey.font: self.font,
                          NSAttributedStringKey.foregroundColor: self.textColor] as [NSAttributedStringKey : Any]
        
        let attributedString = NSMutableAttributedString(string: self.text!, attributes: attributes)
        self.attributedText = attributedString
        
    }
    
    /// 通过html设置attributedText
    ///
    /// - Parameters:
    ///   - html: html网页内容
    ///   - lineSpacing: 行间距
    ///   - font: 字体大小
    public func attributedText(html: String?, lineSpacing: CGFloat = 4.0, font: UIFont = UIFont.systemFont(ofSize: 12), alignment: NSTextAlignment = .left, color: UIColor = UIColor.black) -> Void {
        
        guard let string = html else {
            return
        }
        
        //DispatchQueue.global(qos: .userInitiated).async(execute: {
            
            do {
                let data = string.data(using: .unicode)
            
                let optoins = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
                let attrStr = try NSMutableAttributedString(data: data!, options: optoins, documentAttributes: nil)
            
                // 设置行距
                let range = NSMakeRange(0, attrStr.length)
                let style = NSMutableParagraphStyle()
                style.lineSpacing = lineSpacing
                style.alignment = alignment
                //样式
                attrStr.addAttribute(NSAttributedStringKey.paragraphStyle, value: style, range: range)
                //字体
                attrStr.addAttribute(NSAttributedStringKey.font, value: font, range: range)
                //字体
                attrStr.addAttribute(NSAttributedStringKey.font, value: font, range: range)
                //颜色
                attrStr.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)

                //DispatchQueue.main.async(execute: {
                    self.attributedText = attrStr
//                self.attributedText =
                //})
                
            } catch {
                
                print(error)
            }
        //})
    }
    
    /**
     *  多样性字符串处理
     *
     *  @param original   原始字符串
     *  @param conversion 需转换的字符串
     *  @param font       字体
     *  @param color      颜色
     *
     *  @return 转换好的字符串
     */
    public func diverseStringOriginalStr(original : String,conversionStr conversion : String,withFont font : UIFont,withColor color : UIColor,lineSpacing: CGFloat = 4.0,alignment: NSTextAlignment = .center) ->NSMutableAttributedString{
        
        let range : NSRange = (original as NSString).range(of: conversion as String)
        let str = NSMutableAttributedString(string: original as String)
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        style.alignment = alignment
        str.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
        str.addAttribute(NSAttributedStringKey.font, value: font, range: range)
        str.addAttribute(NSAttributedStringKey.paragraphStyle,value: style,range: range)
        return str
    }
    
    
    
}

extension String {
    
    
    /// html标签字符串转NSAttributedString
    ///
    /// - Returns: NSAttributedString
    func attributedFromHtml() -> NSAttributedString{
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do{
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }catch{
            return NSAttributedString()
        }
    }
}





/*
extension String {
    
    func attributedStringFromHTML(completionBlock:NSAttributedString? ->()) {
        guard let data = dataUsingEncoding(NSUTF8StringEncoding) else {
            print("Unable to decode data from html string: \(self)")
            return completionBlock(nil)
        }
        
        let options = [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                       NSCharacterEncodingDocumentAttribute: NSNumber(unsignedInteger:NSUTF8StringEncoding)]
        
        dispatch_async(dispatch_get_main_queue()) {
            if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
                completionBlock(attributedString)
            } else {
                print("Unable to create attributed string from html string: \(self)")
                completionBlock(nil)
            }
        }
    }
}*/

