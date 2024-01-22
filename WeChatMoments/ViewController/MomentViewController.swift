import MBProgressHUD
import PromiseKit
import UIKit

class MomentViewController: UITableViewController {
    fileprivate let cellIdentifier = "cellIdentifier"
    fileprivate let headerIdentifier = "headerIdentifier"
    fileprivate let footerIdentifier = "footerIdentifier"

    fileprivate var profileImageView: UIImageView!
    fileprivate var avatarImageView: UIImageView!
    fileprivate var nickNameLabel: UILabel!

    fileprivate var dataSource: TweetsDataSource!
    fileprivate var delegate: TweetTableViewDelegate!
    fileprivate var user: User?

    private let userService = UserService()
    private let tweetService = TweetService()

    fileprivate var tweets: [Tweet]? {
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
            indicator?.hide(animated: true)
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

        self.profileImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.profileImageView.leftAnchor.constraint(equalTo: superView.leftAnchor),
            self.profileImageView.rightAnchor.constraint(equalTo: superView.rightAnchor),
            self.profileImageView.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -50),
            self.profileImageView.topAnchor.constraint(equalTo: superView.topAnchor)
        ])
    }

    func addNickNameLabel(_ superView: UIView) {
        self.nickNameLabel = UILabel(frame: .zero)
        self.nickNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        self.nickNameLabel.textColor = .white
        self.nickNameLabel.lineBreakMode = .byTruncatingMiddle
        self.nickNameLabel.numberOfLines = 1
        superView.addSubview(self.nickNameLabel)

        self.nickNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.nickNameLabel.rightAnchor.constraint(equalTo: self.avatarImageView.leftAnchor, constant: -20),
            self.nickNameLabel.topAnchor.constraint(equalTo: self.avatarImageView.topAnchor, constant: 15),
            self.nickNameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 200)
        ])
    }

    func addAvatarImageView(_ superView: UIView) {
        self.avatarImageView = UIImageView(frame: .zero)
        self.avatarImageView.layer.borderColor = UIColor.white.cgColor
        self.avatarImageView.layer.borderWidth = 2
        self.avatarImageView.layer.cornerRadius = 5
        self.avatarImageView.backgroundColor = .white
        self.avatarImageView.contentMode = .scaleAspectFill
        superView.addSubview(self.avatarImageView)

        self.avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.avatarImageView.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -20),
            self.avatarImageView.widthAnchor.constraint(equalToConstant: 75),
            self.avatarImageView.heightAnchor.constraint(equalToConstant: 75)
        ])
        if #available(iOS 11.0, *) {
            self.avatarImageView.rightAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.rightAnchor, constant: -15).isActive = true
        } else {
            self.avatarImageView.rightAnchor.constraint(equalTo: superView.rightAnchor, constant: -15).isActive = true
        }
    }

    func showIndicator() -> MBProgressHUD? {
        let indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        indicator.label.text = "loading..."
        indicator.mode = MBProgressHUDMode.customView

        return indicator
    }

    func setupHeader(user: User) {
        if let url = user.profile {
            ImageHelper.default.getImage(url, forSize: nil) { image in
                self.profileImageView.image = image
            }
        }

        if let url = user.avatar {
            print(url)
            let avatar = ImageHelper.default.getImage(url, forSize: nil)

            self.avatarImageView.image = avatar
        }

        if let nickName = user.nick {
            self.nickNameLabel.text = nickName
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
