//
//  UsersListView.swift
//  PixelTechTest
//
//  Created by Phil Margetson on 18/01/2026.
//
import UIKit

class UsersListView: UIView {
    
    let tableview = UITableView()
    private let spinner = UIActivityIndicatorView(style: .large)
    private let errorMessageLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        setupView()
        setupHierarchy()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        tableview.register(UserListCell.self, forCellReuseIdentifier: UserListCell.reuseID)
        tableview.separatorStyle = .none
        spinner.isHidden = true
        errorMessageLabel.isHidden = true
        errorMessageLabel.numberOfLines = 0 //allow multiline if a verbose error needed
        
    }
    
    private func setupHierarchy() {
        self.addSubview(tableview)
        self.addSubview(errorMessageLabel)
        self.addSubview(spinner)
    }
    
    private func setConstraints() {
        tableview.translatesAutoresizingMaskIntoConstraints = false
        spinner.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        let con = [
            tableview.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableview.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableview.topAnchor.constraint(equalTo: self.topAnchor),
            tableview.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            errorMessageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorMessageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            errorMessageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            errorMessageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ]
        NSLayoutConstraint.activate(con)
    }
    
    func showSpinner() {
        spinner.isHidden = false
        spinner.startAnimating()
    }
    
    func hideSpinner() {
        spinner.isHidden = true
        spinner.stopAnimating()
    }
    
    func showErrorMessage(_ message: String) {
        hideSpinner()
        errorMessageLabel.isHidden = false
        tableview.isHidden = true
        errorMessageLabel.text = message
    }
    
    
    func hideErrorMessage() {
        errorMessageLabel.isHidden = true
        tableview.isHidden = false
    }
}

class UserListCell: UITableViewCell {
    
    static let reuseID = "userListCell"
    
    private let nameLabel = UILabel()
    private let reputationLabel = UILabel()
    private let profileImageView = UIImageView()
    private let followButton = UIButton()
    
    private let outerStack = UIStackView()
    private let vStack = UIStackView()
    
    var onFollowPressed: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupHierarchy()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        profileImageView.image = nil
    }
    
    func update(userName: String, userReputation: String, userImageURL: URL?, isFollowing: Bool) {
        nameLabel.text = userName
        reputationLabel.text = String(userReputation)
        if isFollowing {
            followButton.setTitle("Following", for: .normal)
            followButton.backgroundColor = .red
        } else {
            followButton.setTitle("Follow", for: .normal)
            followButton.backgroundColor = .orange
        }
        guard let imageURL = userImageURL else { return }
        
        Task { [weak self] in //make weak so cell can be deallocated
            guard let self = self else { return }
            let image = await ImageLoader.shared.loadImage(imageURL: imageURL)
            self.profileImageView.image = image
        }
    }
    
    private func setupView() {
        self.selectionStyle = .none
        vStack.axis = .vertical
        outerStack.spacing = 10
        followButton.backgroundColor = .orange
        followButton.setTitle("Follow", for: .normal)
        followButton.addTarget(self, action: #selector(followPressed), for: .touchUpInside)
        
        profileImageView.layer.cornerRadius = 12
        profileImageView.layer.masksToBounds = true
        followButton.layer.cornerRadius = 12
    }
    
    private func setupHierarchy() {
        
        vStack.addArrangedSubview(nameLabel)
        vStack.addArrangedSubview(reputationLabel)
        
        outerStack.addArrangedSubview(profileImageView)
        outerStack.addArrangedSubview(vStack)
        outerStack.addArrangedSubview(followButton)
        self.contentView.addSubview(outerStack)
    }
    
    private func setConstraints() {
        outerStack.translatesAutoresizingMaskIntoConstraints = false
        let con = [
            
            outerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            outerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            outerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            outerStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            profileImageView.widthAnchor.constraint(equalTo: outerStack.heightAnchor, constant: 5),
            followButton.widthAnchor.constraint(equalTo: outerStack.heightAnchor, constant: 5),
            
          
        ]
        NSLayoutConstraint.activate(con)
    }
    
    @objc func followPressed() {
        onFollowPressed?()
    }
}
