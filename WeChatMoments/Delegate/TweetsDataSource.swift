import UIKit

class TweetsDataSource: NSObject, UITableViewDataSource {
    private var cellIdentifier: String
    private var count = 0
    private let countOfIncrease = 5

    var tweets: [Tweet]? {
        didSet {
            self.count = 0
        }
    }

    init(cellIdentifier: String) {
        self.cellIdentifier = cellIdentifier
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let tweets = self.tweets else { return 0 }

        self.count += self.countOfIncrease
        return min(self.count, tweets.count)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: Add the comments count here
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? CommentCell

        if cell == nil {
            cell = CommentCell(style: .default, reuseIdentifier: self.cellIdentifier)
        }
        // TODO: Assign the real comments here
        let comments: [Comment]? = []
        cell?.comment = comments?[indexPath.row]
        return cell!
    }
}
