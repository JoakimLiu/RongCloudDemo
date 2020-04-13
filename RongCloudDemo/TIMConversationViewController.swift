//
//  TIMConversationViewController.swift
//  DecorationCompany
//
//  Created by joakim.liu on 2018/8/17.
//  Copyright © 2018年 to8to. All rights reserved.
//

import UIKit

/// 聊天界面
class TIMConversationViewController: RCConversationViewController {
    // MARK: - Property
    var conversation: RCConversationModel = RCConversationModel()

    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if (conversation.conversationType == .ConversationType_SYSTEM) {
            self.register(TIMNotiMessageCell.self, forMessageClass: TIMNotiMessage.self)
            
            var frame: CGRect = conversationMessageCollectionView.frame
            frame.size.height += chatSessionInputBarControl.frame.size.height
            conversationMessageCollectionView.frame = frame
            chatSessionInputBarControl.isHidden = true
        } else {
            self.chatSessionInputBarControl.pluginBoardView.removeItem(withTag: 1003)
        }
        self.enableNewComingMessageIcon = true
        
        notifyUpdateUnreadMessageCount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

// MARK: - RCMessageCellDelegate 处理
extension TIMConversationViewController: RCMessageCellDelegate {
    /// 点击Cell内容的回调
    ///
    /// - Parameter model: <#model description#>
    override func didTapMessageCell(_ model: RCMessageModel!) {
        super.didTapMessageCell(model)
        print("content:\(model.content)")

    }
    
    /// 点击Cell中用户头像的回调
    ///
    /// - Parameter userId: <#userId description#>
    override func didTapCellPortrait(_ userId: String!) {
        super.didTapCellPortrait(userId)
    }
    
    override func willDisplayMessageCell(_ cell: RCMessageBaseCell!, at indexPath: IndexPath!) {
//        RCImageMessageCell    RCImageMessage
//        RCTextMessageCell     RCTextMessage
//        RCVoiceMessageCell    RCVoiceMessage

    }
    
//     https://developer.rongcloud.cn/ticket/info/3fNHd1zG09QxdHECQA==?type=1
    /*
    override func willSendMessage(_ messageContent: RCMessageContent!) -> RCMessageContent! {
        if messageContent as? RCTextMessage {
            var textMesssage = messageContent as! RCTextMessage
            textMesssage.extra = ""
        }
    }
    */
}

// MARK: - 其他重载方法
extension TIMConversationViewController {
    /// 导航栏返回按钮中的未读消息数提示
    override func notifyUpdateUnreadMessageCount() {
        if (self.allowsMessageCellSelection == true) {
            super.notifyUpdateUnreadMessageCount()
            return
        }
    }
}

