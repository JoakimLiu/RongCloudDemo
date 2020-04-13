//
//  TIMNotiMessageCell.swift
//  DecorationCompany
//
//  Created by joakim.liu on 2018/8/20.
//  Copyright © 2018年 to8to. All rights reserved.
//

import UIKit

let kContentLeft: CGFloat = 15
let SCREEN_WIDTH  = UIScreen.main.bounds.width
/// 通知消息 cell
class TIMNotiMessageCell: RCMessageBaseCell {
    // MARK: - Property
    var notiMessage: TIMNotiMessage = TIMNotiMessage()
    
    lazy var container: UIView = {
        let insets: UIEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 10, right: 15)
        var view = UIView.init(frame: CGRect.init(x: insets.left, y: insets.top, width: SCREEN_WIDTH - insets.left - insets.right, height: 100))
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        return view
    }()
    
    lazy var imgvLogo: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var lblSource: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    lazy var lblSubject: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var lblDetail: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    lazy var line: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var lblMoreTitle: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var imgvArrow: UIImageView = {
        return UIImageView(image: UIImage(named: "icon_im_arrow_right"))
    }()
    
    // MARK: - Life cycle
    override init!(frame: CGRect) {
        super.init(frame: frame)
    
        self.backgroundColor = .clear
        self.clipsToBounds = true
        
        self.contentView.addSubview(self.container)
        self.container.addSubview(self.imgvLogo)
        self.container.addSubview(self.lblSource)
        self.container.addSubview(self.lblSubject)
        self.container.addSubview(self.lblDetail)
        self.container.addSubview(self.line)
        self.container.addSubview(self.lblMoreTitle)
        self.container.addSubview(self.imgvArrow)
        
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(contentTapAction))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var topMargin: CGFloat = 10
        if isDisplayMessageTime {
            topMargin += 45
        }
    
        let insets: UIEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 10, right: 15)
        container.frame = CGRect(x: insets.left, y: insets.top + topMargin, width: SCREEN_WIDTH - insets.left - insets.right, height: 100)
        
        imgvLogo.frame = CGRect(x: kContentLeft, y: 12, width: 28, height: 28)
        
        let width: CGFloat = TIMNotiMessageCell.kDetailContentWith()
        
        lblSource.frame = CGRect(x: 50, y: 16, width: TIMNotiMessageCell.kDetailContentWith() - 50, height: 20)
        
        let subjectSize: CGSize = lblSubject.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        
        lblSubject.frame = CGRect(x: kContentLeft, y: 52, width: subjectSize.width, height: subjectSize.height)
        lblDetail.frame = CGRect(x: lblSubject.frame.minX, y: lblSubject.frame.maxY + kContentLeft, width: width, height: notiMessage.attriHeight)
        
        var lineTop: CGFloat = lblSubject.frame.maxY + kContentLeft
        if (lblDetail.text != nil) && (lblDetail.text?.count)! > 0 {
            lineTop = lblDetail.frame.maxY
        }
        line.frame = CGRect(x: 0, y: lineTop, width: container.frame.width, height: 1)
        
        lblMoreTitle.frame = CGRect(x: kContentLeft, y: line.frame.maxY + 14, width: TIMNotiMessageCell.kDetailContentWith() - 30, height: 20)
//        imgvArrow.centerY = lblMoreTitle.centerY
        
        var frame: CGRect = container.frame
        frame.size.height = lblMoreTitle.frame.maxY + 14
        container.frame = frame
    }
    
    override func setDataModel(_ model: RCMessageModel!) {
        super.setDataModel(model)
        guard ((model.content as? TIMNotiMessage) != nil) else {
            return
        }
        notiMessage = model.content as! TIMNotiMessage
        
//        self.imgvLogo.t_setImageWithURLString(notiMessage.sourceImg, placeHolderImage: "icon_chat_news")
        self.lblSource.text = notiMessage.subject
        self.lblSubject.text = notiMessage.des
        self.lblDetail.attributedText = notiMessage.attriContentAtr
        self.lblMoreTitle.text = notiMessage.moreBtnName
        
        layoutSubviews()
    }
    
    override class func size(for: RCMessageModel!, withCollectionViewWidth: CGFloat, referenceExtraHeight: CGFloat) -> CGSize {
        guard ((`for`.content as? TIMNotiMessage) != nil) else {
            return CGSize(width: withCollectionViewWidth, height: 0)
        }
        let notiMsg = `for`.content as! TIMNotiMessage
        let subject: String = notiMsg.des
        
        let width: CGFloat = TIMNotiMessageCell.kDetailContentWith()
        let subjectHeight: CGFloat = subject.getTextSize(font: UIFont.systemFont(ofSize: 16), size: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)).size.height
        
        var height: CGFloat = 52 + subjectHeight // lblSubject
        let detailHeight: CGFloat = notiMsg.attriHeight
        if detailHeight > 0 { // lblDetail
            height += detailHeight
        }
        height += kContentLeft
        height += (14 + 20) // lblMoreTitle
        height += 14 // bottom
        
        let insetHeight: CGFloat = UIEdgeInsets(top: 5, left: 15, bottom: 10, right: 15).top + UIEdgeInsets(top: 5, left: 15, bottom: 10, right: 15).bottom // inset
        height += insetHeight

        return CGSize(width: withCollectionViewWidth, height: (height + referenceExtraHeight))
    }

    // MARK: - Help
    class func kDetailContentWith() -> CGFloat {
        let insets: UIEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 10, right: 15)
        return SCREEN_WIDTH - insets.left - insets.right - kContentLeft*2
    }
    
    // MARK: - Event
    @objc func contentTapAction() {
        self.delegate.didTapMessageCell!(self.model)
    }
    
}


extension String {
    func getTextSize(font : UIFont,size : CGSize) -> CGRect {
        
        let tempstr: NSString = self as NSString!
        
        let attributes = [NSAttributedStringKey.font : font]
        
        let textRect = tempstr.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return textRect
    }
}
