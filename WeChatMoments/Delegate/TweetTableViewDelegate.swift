import UIKit

class TweetTableViewDelegate: NSObject, UITableViewDelegate {
    var tweets: [Tweet]?

    private let characterCountForComments = 22
    private let characterCountForContent = 22
    private let countOfImagesPerLine = 3

    private var headerIdentifier: String
    private var footerIdentifier: String

    init(headerIdentifier: String, footerIdentifier: String) {
        self.headerIdentifier = headerIdentifier
        self.footerIdentifier = footerIdentifier
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // TODO: Calculate the height for each comment cell here, using the method below
        // height(for comment: Comment, on tableView: UITableView) -> CGFloat
        return 0
    }
    
    private func height(for comment: Comment, on tableView: UITableView) -> CGFloat {
        let sender = comment.sender
        let username = sender?.username ?? ""
        let content = comment.content ?? ""
        let text =  username + content

        let font = UIFont.boldSystemFont(ofSize: Constants.FONT_SIZE_COMMENT)
        let widthOfContent = tableView.bounds.width - Constants.SENDER_AVATAR_SIZE.width - 40
        let height = text.heightWithConstrainedWidth(width: widthOfContent, font: font)

        return height + CGFloat(8)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tweetView = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.headerIdentifier) as! TweetView
        if let tweet = tweets?[section] {
            tweetView.tweet = tweet
        }

        return tweetView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.footerIdentifier)
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let tweet = tweets?[section] else {
            return 0.0
        }

        var height: CGFloat = Constants.FONT_SIZE_CONTENT + CGFloat(Constants.TWEET_AVATAR_OFFSET)

        if let content = tweet.content {
            height += self.getHeightOf(content: content, in: tableView)
        }

        // TODO: set the real images array here and show the images on cell
        let images = [Img]()
        let imgUrls = images.map { $0.url }
        height += self.getHeightOf(imageUrls: imgUrls, in: tableView)

        if height < Constants.SENDER_AVATAR_SIZE.height {
            height = Constants.SENDER_AVATAR_SIZE.height
        }

        return CGFloat(height)
    }

    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard let tweets = self.tweets else {
            return
        }

        if (section + 1) == tableView.numberOfSections,
           tweets.count > tableView.numberOfSections
        {
            tableView.reloadData()
        }
    }

    private func getHeightOf(content: String?, in tableView: UITableView) -> CGFloat {
        var heightOfContent: CGFloat = 0
        if let text = content {
            let widthOfContent = tableView.bounds.width - Constants.SENDER_AVATAR_SIZE.width - Constants.TWEET_AVATAR_OFFSET - Constants.TWEET_SENDER_LEFT_OFFSET
            let font = UIFont.boldSystemFont(ofSize: Constants.FONT_SIZE_CONTENT)
            heightOfContent = text.heightWithConstrainedWidth(width: CGFloat(widthOfContent), font: font) + Constants.TWEET_CONTENT_TOP_OFFSET
        }

        return heightOfContent
    }

    private func getHeightOf(imageUrls: [String]?, in tableView: UITableView) -> CGFloat {
        var height: CGFloat = 0

        guard let urls = imageUrls else {
            return height
        }

        if urls.count == 1 {
            return (Constants.TWEET_IMAGE_SPEPERATOR_SPACE + Constants.IMAGE_SIZE.height) * 2
        }

        var numberOfImagelines = urls.count / self.countOfImagesPerLine

        numberOfImagelines = urls.count % self.countOfImagesPerLine > 0 ? (numberOfImagelines + 1) : numberOfImagelines
        height += CGFloat(numberOfImagelines) * (Constants.IMAGE_SIZE.height + Constants.TWEET_IMAGE_SPEPERATOR_SPACE)
        height += Constants.TWEET_IMAGE_SPEPERATOR_SPACE

        return height + 8
    }
}
