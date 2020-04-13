//
//  TIMConversationListViewController.swift
//  DecorationCompany
//
//  Created by joakim.liu on 2018/8/17.
//  Copyright © 2018年 to8to. All rights reserved.
//

import UIKit

/// 聊天列表界面
class TIMConversationListViewController: RCConversationListViewController {
    // MARK: - Life cycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        // 设置显示数据类型
        self.setDisplayConversationTypes([NSNumber(value: RCConversationType.ConversationType_PRIVATE.rawValue),
                                          NSNumber(value: RCConversationType.ConversationType_SYSTEM.rawValue),NSNumber(value: RCConversationType.ConversationType_GROUP.rawValue)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        self.conversationListTableView.separatorStyle = .none
        self.conversationListTableView.tableFooterView = UIView()
        self.showConnectingStatusOnNavigatorBar = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.notifyUpdateUnreadMessageCount()
    }
    
}


// MARK: - 点击事件的回调
extension TIMConversationListViewController {
    override func onSelectedTableRow(_ conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, at indexPath: IndexPath!) {
        selectedAction(model)
    }
    
    override func didTapCellPortrait(_ model: RCConversationModel!) {
        selectedAction(model)
    }
    
    func selectedAction(_ model: RCConversationModel!) {
        if (model.conversationModelType == .CONVERSATION_MODEL_TYPE_NORMAL) {
            print("objectName:\(model.objectName)")
            
            let chatVC: TIMConversationViewController = TIMConversationViewController()
            chatVC.conversationType = model.conversationType
            chatVC.targetId = model.targetId
            chatVC.title = model.conversationTitle
            chatVC.conversation = model
            chatVC.unReadMessage = model.unreadMessageCount
            chatVC.enableNewComingMessageIcon = true //开启消息提醒
            chatVC.enableUnreadMessageIcon = true
            
            // 如果是单聊，不显示发送方昵称
            if (model.conversationType == .ConversationType_PRIVATE) {
                chatVC.displayUserNameInCell = false
            }
            
            if (model.conversationType == .ConversationType_SYSTEM) {
                chatVC.title = "通知消息"
            }
            self.navigationController?.pushViewController(chatVC, animated: true)
        }
    }
    
}

// MARK: - 收到消息处理
extension TIMConversationListViewController {
    override func didReceiveMessageNotification(_ notification: Notification!) {
        super.didReceiveMessageNotification(notification)
    }
    
    override func notifyUpdateUnreadMessageCount() {
        
    }
}

// MARK: - Cell加载显示的回调
extension TIMConversationListViewController {
    /// 即将加载列表数据源的回调
    ///
    /// - Parameter dataSource: <#dataSource description#>
    /// - Returns: <#return value description#>
    override func willReloadTableData(_ dataSource: NSMutableArray!) -> NSMutableArray! {
        return dataSource
    }
    
    override func willDisplayConversationTableCell(_ cell: RCConversationBaseCell!, at indexPath: IndexPath!) {
        let model = cell.model
        guard let listCell = cell as? RCConversationCell else {
            return
        }
        //        print("model name:\(String(describing: model?.lastestMessage.senderUserInfo.name))")
        if model?.conversationType == .ConversationType_SYSTEM { // 系统通知
            if let noticeMessage = model?.lastestMessage as? TIMNotiMessage {
                listCell.conversationTitle.text = "通知消息"
                listCell.messageContentLabel.text = noticeMessage.subject // 展示内容处理
//                if let imageView = listCell.value(forKey: "headerImageView") as? UIImageView {
//                    imageView.image = UIImage(named: "icon_chat_news")
//                }
            }
        }
    }

}

// MARK: - 删除会话的回调
extension TIMConversationListViewController {
    override func didDeleteConversationCell(_ model: RCConversationModel!) {
        RCIMClient.shared().deleteMessages(model.conversationType, targetId: model.targetId, success: nil, error: { (code) in })
    }
}
