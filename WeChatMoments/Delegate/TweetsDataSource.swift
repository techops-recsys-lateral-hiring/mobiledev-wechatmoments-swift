//
//  TweetsDataSource.swift
//  WeChatMoments
//


import UIKit

class TweetsDataSource: NSObject, UITableViewDataSource {
    private var cellIdentifier: String
    private var count = 0
    private let countOfIncrease = 5
    
    var tweets: [[String: Any]]? {
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
        if let tweet: [String: Any] = tweets?[section],
           let comments = tweet["comments"] as? [[String: Any]] {
            return comments.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? CommentCell

        if cell == nil {
            cell = CommentCell(style: .default, reuseIdentifier: self.cellIdentifier)
        }
        let tweet = tweets?[indexPath.section]
        let comments = tweet?["comments"] as? [[String: Any]]
        cell?.comment = comments?[indexPath.row]
        return cell!
    }
}
