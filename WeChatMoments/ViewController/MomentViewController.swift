//
//  ViewController.swift
//  WeChatMoments
//


import MBProgressHUD
import PromiseKit
import SnapKit
import UIKit

class MomentViewController: UITableViewController {
    fileprivate let cellIdentifier = "cellIdentifier"
    fileprivate let headerIdentifier = "headerIdentifier"
    fileprivate let footerIdentifier = "footerIdentifier"

    fileprivate var profileImageView: UIImageView!
    fileprivate var avatarImageView: UIImageView!
    fileprivate var nickNameLable: UILabel!

    fileprivate var dataSource: TweetsDataSource!
    fileprivate var delegate: TweetTableViewDelegate!
    fileprivate var user: [String: Any]?

    private let userService = UserService()
    private let tweetService = TweetService()

    fileprivate var tweets: [[String: Any]]? {
        didSet {
            self.dataSource.tweets = self.tweets
            self.delegate.tweets = self.tweets
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.loadData()
        self.addRefreshControl()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.orientationIsChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        super.viewWillAppear(animated)
    }

    @objc
    func orientationIsChanged() {
        self.updateViewSConstraints()
    }

    func loadData() {
        let indicator = self.showIndicator()
        let group = DispatchGroup()

        group.enter()
        self.userService.getUserProfile(Constants.USER_NAME).done { user in
            if let user = user {
                self.setupHeader(user: user)
                self.user = user
            }
        }.catch { error in
            print(error)
        }.finally {
            group.leave()
        }

        group.enter()

        self.loadTweetsData().catch { error in
            print(error)
        }.finally {
            group.leave()
        }

        group.notify(queue: DispatchQueue.main) {
            indicator?.hide(true)
        }
    }

    func loadTweetsData() -> Promise<Void> {
        return self.tweetService.getTweets(Constants.USER_NAME).map { tweets in
            self.tweets = tweets
        }
    }
}

private extension MomentViewController {
    func setupTableView() {
        self.dataSource = TweetsDataSource(cellIdentifier: self.cellIdentifier)
        self.delegate = TweetTableViewDelegate(headerIdentifier: self.headerIdentifier, footerIdentifier: self.footerIdentifier)

        self.tableView = UITableView(frame: self.view.bounds, style: .grouped)
        self.tableView.dataSource = self.dataSource
        self.tableView.delegate = self.delegate
        self.tableView.tableHeaderView = self.getHeaderView()
        self.tableView.allowsSelection = false
        self.tableView.showsVerticalScrollIndicator = false

        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .white

        self.tableView.estimatedRowHeight = 0
        self.tableView.estimatedSectionHeaderHeight = 0
        self.tableView.estimatedSectionFooterHeight = 0

        self.tableView.register(CommentCell.self, forCellReuseIdentifier: self.cellIdentifier)
        self.tableView.register(FootView.self, forHeaderFooterViewReuseIdentifier: self.footerIdentifier)
        self.tableView.register(TweetView.self, forHeaderFooterViewReuseIdentifier: self.headerIdentifier)
        self.tableView.separatorStyle = .none
    }

    func getHeaderView() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: Int(self.view.bounds.width), height: 370))

        self.addProfileImage(headerView)
        self.addAvatarImageView(headerView)
        self.addNickNameLabel(headerView)

        return headerView
    }

    func addProfileImage(_ superView: UIView) {
        self.profileImageView = UIImageView(frame: .zero)
        self.profileImageView.backgroundColor = .gray
        self.profileImageView.contentMode = .scaleAspectFill
        self.profileImageView.clipsToBounds = true
        superView.addSubview(self.profileImageView)

        self.profileImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-50)
            make.top.equalToSuperview()
        }
    }

    func addNickNameLabel(_ superView: UIView) {
        self.nickNameLable = UILabel(frame: .zero)
        self.nickNameLable.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        self.nickNameLable.textColor = .white
        self.nickNameLable.lineBreakMode = .byTruncatingMiddle
        self.nickNameLable.numberOfLines = 1
        superView.addSubview(self.nickNameLable)

        self.nickNameLable.snp.makeConstraints { make in
            make.right.equalTo(self.avatarImageView.snp_left).offset(-20)
            make.top.equalTo(self.avatarImageView).offset(15)
            make.width.lessThanOrEqualTo(200)
        }
    }

    func addAvatarImageView(_ superView: UIView) {
        self.avatarImageView = UIImageView(frame: .zero)
        self.avatarImageView.layer.borderColor = UIColor.white.cgColor
        self.avatarImageView.layer.borderWidth = 2
        self.avatarImageView.layer.cornerRadius = 5
        self.avatarImageView.backgroundColor = .white
        self.avatarImageView.contentMode = .scaleAspectFill

        superView.addSubview(self.avatarImageView)
        self.avatarImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            if #available(iOS 11.0, *) {
                make.right.equalTo(superView.safeAreaLayoutGuide.snp.right).offset(-15)
            } else {
                make.right.equalToSuperview().offset(-15)
            }

            make.width.equalTo(75)
            make.height.equalTo(75)
        }
    }

    func showIndicator() -> MBProgressHUD? {
        let indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        indicator?.labelText = "loading..."
        indicator?.mode = MBProgressHUDMode.customView

        return indicator
    }

    func setupHeader(user: [String: Any]) {
        if let url = user["profile-image"] as? String {
            ImageHelper.default.getImage(url, forSize: nil) { image in
                self.profileImageView.image = image
            }
        }

        if let url = user["avatar"] as? String {
            print(url)
            let avatar = ImageHelper.default.getImage(url, forSize: nil)

            self.avatarImageView.image = avatar
        }

        if let nickName = user["nick"] as? String {
            self.nickNameLable.text = nickName
        }
    }

    func addRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = .black
        refreshControl.tintColor = UIColor.white

        refreshControl.addTarget(self, action: #selector(self.reloadTweets), for: .valueChanged)
        self.refreshControl = refreshControl
    }

    @objc
    func reloadTweets(_ sender: UIRefreshControl) {
        self.loadTweetsData().done { _ in
            sender.endRefreshing()
        }.catch { error in print(error) }
    }

    func updateViewSConstraints() {
        let isPortraint = UIDevice.current.orientation.isPortrait
        let headerView = self.getHeaderView()
        self.tableView.tableHeaderView = nil

        if isPortraint {
            self.tableView.tableHeaderView = headerView
        } else {
            headerView.frame = CGRect(x: 0, y: 0, width: Int(self.view.bounds.width), height: 230)

            self.tableView.tableHeaderView = headerView
        }

        if let user = self.user {
            self.setupHeader(user: user)
        }
    }
}
