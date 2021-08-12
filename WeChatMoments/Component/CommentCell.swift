//
//  CommentCell.swift
//  WeChatMoments
//


import UIKit

class CommentCell: UITableViewCell {
    var comment: [String: Any]! {
        didSet {
            let sender = self.comment["sender"] as? [String: Any]
            var displayName = sender?["username"] as? String
            if let nick = sender?["nick"] as? String {
                displayName = nick
            }

            self.btnCommentSender.setTitle(displayName, for: .normal)
            self.lblComment.text = ":\(self.comment["content"] as? String ?? "")"
        }
    }

    private var lblComment: UILabel
    private var btnCommentSender: UIButton

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.lblComment = UILabel()
        self.btnCommentSender = UIButton()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.btnCommentSender.setTitleColor(.blue, for: .normal)
        self.btnCommentSender.titleLabel?.font = UIFont.systemFont(ofSize: Constants.FONT_SIZE_COMMENT)
        self.btnCommentSender.backgroundColor = UIColor.commentsBackgroudColor()

        self.addSubview(self.btnCommentSender)
        let leftPadding = Constants.SENDER_AVATAR_SIZE.width + 20
        self.btnCommentSender.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(leftPadding)
        }

        self.lblComment.backgroundColor = UIColor.commentsBackgroudColor()
        self.lblComment.textColor = UIColor.black

        self.lblComment.font = UIFont.systemFont(ofSize: Constants.FONT_SIZE_COMMENT)
        self.lblComment.numberOfLines = 0

        self.addSubview(self.lblComment)
        self.lblComment.snp.makeConstraints { make in
            make.top.equalTo(btnCommentSender)
            make.bottom.equalTo(btnCommentSender)
            make.right.equalToSuperview().offset(-20)
            make.left.equalTo(btnCommentSender.snp_right)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func getComment(senderName: String, comment: String) -> NSAttributedString {
        let msg = "\(senderName):\(self.comment["content"] as? String ?? "")"
        let range = (msg as NSString).range(of: senderName)
        let attrString = NSMutableAttributedString(string: msg)
        attrString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.blue], range: range)

        return attrString
    }
}
