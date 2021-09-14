import UIKit

class CommentCell: UITableViewCell {
    var comment: Comment! {
        didSet {
            let sender = self.comment.sender
            var displayName = sender?.username
            if let nick = sender?.nick {
                displayName = nick
            }

            self.btnCommentSender.setTitle(displayName, for: .normal)
            self.lblComment.text = ":\(self.comment.content ?? "")"
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

        self.btnCommentSender.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            btnCommentSender.topAnchor.constraint(equalTo: self.topAnchor),
            btnCommentSender.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            btnCommentSender.leftAnchor.constraint(equalTo: self.leftAnchor, constant: leftPadding)
        ])

        self.lblComment.backgroundColor = UIColor.commentsBackgroudColor()
        self.lblComment.textColor = UIColor.black

        self.lblComment.font = UIFont.systemFont(ofSize: Constants.FONT_SIZE_COMMENT)
        self.lblComment.numberOfLines = 0

        self.addSubview(self.lblComment)

        self.lblComment.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.lblComment.topAnchor.constraint(equalTo: btnCommentSender.topAnchor),
            self.lblComment.bottomAnchor.constraint(equalTo: btnCommentSender.bottomAnchor),
            self.lblComment.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            self.lblComment.leftAnchor.constraint(equalTo: btnCommentSender.rightAnchor)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func getComment(senderName: String, comment: String) -> NSAttributedString {
        let msg = "\(senderName):\(self.comment.content ?? "")"
        let range = (msg as NSString).range(of: senderName)
        let attrString = NSMutableAttributedString(string: msg)
        attrString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.blue], range: range)

        return attrString
    }
}
