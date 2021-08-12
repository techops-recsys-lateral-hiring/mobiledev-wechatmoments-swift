//
//  FootView.swift
//  WeChatMoments
//


import UIKit


class FootView: UITableViewHeaderFooterView {
    private var lineView: UIView!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        self.lineView = UIView()
        self.lineView.backgroundColor = UIColor.commentsBackgroudColor()
        self.addSubview(self.lineView)
    }

    override func layoutSubviews() {
        self.lineView.frame = CGRect(x: 0, y: self.frame.height - 0.5, width: self.frame.width, height: 0.5)
    }
}

