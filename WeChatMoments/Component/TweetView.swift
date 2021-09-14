import UIKit

class TweetView: UITableViewHeaderFooterView {
    private let numberOfImages = 8
    private var avatarView: UIImageView!
    private var lblContent: UILabel!
    private var btnSender: UIButton!
    private var lineView: UIView!
    private let imageViewTagOffset = 80

    var tweet: Tweet! {
        didSet {
            self.setContent(tweet.content)
            // TODO: Assign the name, avatar and imageURLs
//            self.btnSender.setTitle(nick ?? username, for: .normal)
//            self.setSenderAvatar(avatar)
//            self.addImageViews(imageURLs)
        }
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        self.setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setupViews() {
        self.avatarView = UIImageView(frame: .zero)
        self.avatarView.image = UIImage(named: "emptyImage.png")
        self.avatarView.layer.cornerRadius = 5
        self.avatarView.clipsToBounds = true
        self.contentView.addSubview(self.avatarView)

        self.avatarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.avatarView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Constants.TWEET_AVATAR_OFFSET),
            self.avatarView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.TWEET_AVATAR_OFFSET),
            self.avatarView.widthAnchor.constraint(equalToConstant: Constants.SENDER_AVATAR_SIZE.width),
            self.avatarView.heightAnchor.constraint(equalToConstant: Constants.SENDER_AVATAR_SIZE.height)
        ])

        self.btnSender = UIButton(type: .system)
        self.btnSender.isUserInteractionEnabled = false
        self.btnSender.titleLabel?.font = UIFont.systemFont(ofSize: Constants.FONT_SIZE_CONTENT)
        self.btnSender.setTitleColor(UIColor.blue, for: .normal)

        self.contentView.addSubview(self.btnSender)

        self.btnSender.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.btnSender.leftAnchor.constraint(equalTo: self.avatarView.rightAnchor, constant: Constants.TWEET_SENDER_LEFT_OFFSET),
            self.btnSender.topAnchor.constraint(equalTo: self.avatarView.topAnchor),
            self.btnSender.heightAnchor.constraint(equalToConstant: Constants.FONT_SIZE_CONTENT),
            self.btnSender.widthAnchor.constraint(lessThanOrEqualToConstant: 100)
        ])

        self.lblContent = UILabel()
        self.lblContent.textColor = UIColor.black
        self.lblContent.font = UIFont.systemFont(ofSize: Constants.FONT_SIZE_CONTENT)
        self.lblContent.numberOfLines = 0

        self.contentView.addSubview(self.lblContent)

        self.lblContent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.lblContent.leftAnchor.constraint(equalTo: self.btnSender.leftAnchor),
            self.lblContent.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.lblContent.topAnchor.constraint(equalTo: self.btnSender.bottomAnchor, constant: Constants.TWEET_CONTENT_TOP_OFFSET)
        ])
    }

    private func setSenderAvatar(_ avatar: Any?) {
        if let avatar = avatar as? String {
            ImageHelper.default.getImage(avatar, forSize: Constants.SENDER_AVATAR_SIZE) {
                image in
                self.avatarView?.image = image
                self.layoutIfNeeded()
            }
        } else {
            self.avatarView?.image = UIImage(named: "emptyImage.png")
        }
    }

    private func setContent(_ content: String?) {
        self.lblContent.text = content ?? ""
        self.lblContent.sizeToFit()
    }

    private func addImageViews(_ images: [String]?) {
        self.removeImageViews()

        guard let paths = images else {
            return
        }

        if paths.count == 1 {
            let imgView = self.addImage(path: paths[0], index: 0)

            self.addContraintsForImage(imageView: imgView, leadingConstant: Constants.TWEET_IMAGE_SPEPERATOR_SPACE, topConstant: Constants.TWEET_IMAGE_SPEPERATOR_SPACE, size: CGSize(width: Constants.IMAGE_SIZE.width * 2, height: Constants.IMAGE_SIZE.height * 2))

            return
        }

        for (index, path) in paths.enumerated() {
            // only show 9 images
            if index > self.numberOfImages {
                return
            }

            let imageView = self.addImage(path: path, index: index)

            let seperateSpace = Constants.TWEET_IMAGE_SPEPERATOR_SPACE
            var xOffSet: CGFloat = 0
            var yOffSet: CGFloat = 0
            if (index + 1) <= 3 {
                xOffSet = CGFloat(index * Int(Constants.IMAGE_SIZE.width + seperateSpace))
            } else {
                xOffSet = CGFloat(index % 3 * Int(Constants.IMAGE_SIZE.width + seperateSpace))
                yOffSet = CGFloat(index / 3 * (Int(Constants.IMAGE_SIZE.height) + Int(seperateSpace)))
            }
            let leadingConstant = xOffSet
            let topConstant = CGFloat(seperateSpace + yOffSet)

            self.addContraintsForImage(imageView: imageView, leadingConstant: leadingConstant, topConstant: topConstant)
        }
    }

    private func addImage(path: String, index: Int) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "emptyImage.png")

        imageView.tag = self.imageViewTagOffset + index
        ImageHelper.default.getImage(path, forSize: Constants.IMAGE_SIZE) { image in
            if let image = image {
                imageView.image = image
                self.layoutIfNeeded()
            }
        }

        self.contentView.addSubview(imageView)

        return imageView
    }

    private func removeImageViews() {
        for i in 0 ... self.numberOfImages {
            var imageView = self.viewWithTag(self.imageViewTagOffset + i)
            guard let view = imageView else {
                continue
            }

            view.removeConstraints(view.constraints)
            imageView?.removeFromSuperview()
            imageView = nil
        }
    }

    private func addContraintsForImage(imageView: UIImageView, leadingConstant: CGFloat, topConstant: CGFloat, size: CGSize = Constants.IMAGE_SIZE) {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: btnSender.leftAnchor, constant: leadingConstant),
            imageView.widthAnchor.constraint(equalToConstant: size.width),
            imageView.heightAnchor.constraint(equalToConstant: size.height)
        ])
        if let _ = tweet.content {
            imageView.topAnchor.constraint(equalTo: lblContent.bottomAnchor, constant: topConstant).isActive = true
        } else {
            imageView.topAnchor.constraint(equalTo: btnSender.bottomAnchor, constant: topConstant).isActive = true
        }
    }
}
