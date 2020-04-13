//
//  TIMNotiMessage.swift
//  DecorationCompany
//
//  Created by joakim.liu on 2018/8/20.
//  Copyright © 2018年 to8to. All rights reserved.
//

import UIKit
import HandyJSON

/*
 // 网页 API 测试发送消息路径为：消息服务 -> 发送系统消息。 content 内容如下：
 {"content": {"des":"您好，小雪邀请您参加会议，请您安排好手头的工作，准时参加会议。您好，小雪邀请您参加会议，请您安排好手头的工作，准时参加会议。您好，小雪邀请您参加会议，请您安排好手头的工作，准时参加会议。","pageType":17,"data":{"orderId":21223,"projectType":0,"userType":1,"type":1,"url":"https://mqc.to8to.com/#/site-management/site-detail?id=1585338"},"pcPageUrl":"http://www.oa.com","subject":"辅材订单1","moreBtnName":"查看详情","source":"renovationcompany","sourceImg":"https://oapp.to8to.com/app/download/viewaimg?img=97/headphoto_1397.jpg&mod=2&utime=1511766828461","content":"<div style=\"display:flex;\"><div style=\"width:100px;font-family: MicrosoftYaHei; font-size: 14px; color: #666666;\">会议预订人:</div><div style=\"flex:1;font-family: MicrosoftYaHei; font-size: 14px; color: #333333;\">小雪</div></div><div style=\"display:flex;\"><div style=\"width:100px;font-family: MicrosoftYaHei; font-size: 14px; color: #666666;\">会议日期:</div><div style=\"flex:1;font-family: MicrosoftYaHei; font-size: 14px; color: #333333;\">2017-11-21 星期二</div></div><div style=\"display:flex;\"><div style=\"width:100px;font-family: MicrosoftYaHei; font-size: 14px; color: #666666;\">会议时间:</div><div style=\"flex:1;font-family: MicrosoftYaHei; font-size: 14px; color: #333333;\">13:30-15:00</div></div><div style=\"display:flex;\"><div style=\"width:100px;font-family: MicrosoftYaHei; font-size: 14px; color: #666666;\">会议室:</div><div style=\"flex:1;font-family: MicrosoftYaHei; font-size: 14px; color: #333333;\">广州塔</div></div><div style=\"display:flex;\"><div style=\"width:100px;font-family: MicrosoftYaHei; font-size: 14px; color: #666666;\">会议主题:</div><div style=\"flex:1;font-family: MicrosoftYaHei; font-size: 14px; color: #333333;\">设计分享石帆胜丰三sfsdfsf史蒂芬森电风扇电风扇电风扇电风扇电风扇的</div></div>"}}
 */

/// 通知消息
class TIMNotiMessage: RCMessageContent, HandyJSON {
    // MARK: - Property
    var source: String = ""
    var sourceImg: String = ""
    var subject: String = ""
    var des: String = ""
    var img: String = ""
    
    /// 以下数据（可选）
    /// 查看详情
    var moreBtnName: String = ""
    var content: String = "" {
        didSet{
            self.contentAtr()
        }
    }
    var pcPageUrl: String = ""
    var iosPageUrl: String = ""
    var androidPageUrl: String = ""
    
    /// 页面跳转类型
    var pageType: Int = 0
    /// 页面跳转相关数据
    var data: [String: Any] = [:]
    
    /// computed property
    var attriContentAtr: NSAttributedString = NSAttributedString()
    var attriHeight: CGFloat = 0
    
    required override init() {
        
    }
 
    func contentAtr() {
        if content.count <= 0 {
            return
        }
        guard let data = content.data(using: .utf8) else { return }
        do {
            attriContentAtr = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil) //
            attriHeight = self.heightWithMaxWidth(attriString: attriContentAtr, width: TIMNotiMessageCell.kDetailContentWith())
        } catch {
            
        }
    }
    
    func heightWithMaxWidth(attriString: NSAttributedString, width: CGFloat) -> CGFloat {
        let rect: CGRect = attriString.boundingRect(with: CGSize(width: width, height: 100000), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return ceil(rect.size.height)
    }

}

// MARK: - RCMessageCoding
extension TIMNotiMessage {
    override func encode() -> Data! {
        if !JSONSerialization.isValidJSONObject(self.toJSON()) {
            return nil
        }
        return try? JSONSerialization.data(withJSONObject: self.toJSON(), options: [])
    }
    
    override func decode(with data: Data!) {
        var outerDic: [String: Any]?
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            outerDic = json as? [String : Any]
        } catch _ {
            return
        }
        guard outerDic != nil else {
            return
        }
        
        /// 对字典、字符串都做处理
        guard let innnerContent: Any = outerDic!["content"] else {
            return
        }
        
        var tmpDic: [String: Any]? // 临时字典
        
        if ((innnerContent as? [String: Any]) != nil) { // 如果是字典
            tmpDic = innnerContent as? [String : Any]
        } else {
            if ((innnerContent as? String) != nil) { // 如果是字符串
                do {
                    let innnerContentString =  innnerContent as! String
                    let json = try JSONSerialization.jsonObject(with: innnerContentString.data(using: .utf8)!, options: .mutableContainers)
                    tmpDic = json as? [String: Any]
                } catch _ {
                    return
                }
            }
        }

        guard let dic = tmpDic else {
            return
        }
        
        if let source = dic["source"] as? String {
            self.source = source
        }
        if let sourceImg = dic["sourceImg"] as? String {
            self.sourceImg = sourceImg
        }
        if let subject = dic["subject"] as? String {
            self.subject = subject
        }
        if let des = dic["des"] as? String {
            self.des = des
        }
        if let img = dic["img"] as? String {
            self.img = img
        }
        if let moreBtnName = dic["moreBtnName"] as? String {
            self.moreBtnName = moreBtnName
        }
        if let content = dic["content"] as? String {
            self.content = content
        }
        if let iosPageUrl = dic["iosPageUrl"] as? String {
            self.iosPageUrl = iosPageUrl
        }
        
        if let pageType = dic["pageType"] as? Int {
            self.pageType = pageType
        }
        if let data = dic["data"] as? [String: Any] {
            self.data = data
        }
    }
    
    override class func getObjectName() -> String! {
        return "T8T:NoticeTxtMsg"
    }
    
    override func getSearchableWords() -> [String]! {
        return [content]
    }
}

// MARK: - RCMessagePersistentCompatible
extension TIMNotiMessage {
    override static func persistentFlag() -> RCMessagePersistent {
        return RCMessagePersistent.MessagePersistent_ISCOUNTED
    }
}

