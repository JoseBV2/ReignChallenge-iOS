//
//  CommentsViewCell.swift
//  ReignMobileChallenge
//
//  Created by Jóse Bustamante on 20/09/22.
//

import UIKit

class CommentsViewCell: UITableViewCell {
    
    var commentLabel = UILabel()
    var authorTimeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(comments: CommentsHitsResponse) {
        commentLabel.text = comments.storyTitle
        authorTimeLabel.text = "\(comments.author) \(comments.formattedDate())"
    }
}

private extension CommentsViewCell {
    
    func setupUI() {
        descriptionLabelConfigurations()
        authorTimeLabelConfigurations()
    }
    
    func descriptionLabelConfigurations() {
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.numberOfLines = 2
        commentLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        commentLabel.textColor = .black
        contentView.addSubview(commentLabel)
        commentLabelConstraints()
    }
    
    func authorTimeLabelConfigurations() {
        authorTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        authorTimeLabel.numberOfLines = 0
        authorTimeLabel.font = UIFont.systemFont(ofSize: 14.0)
        authorTimeLabel.textColor = .systemGray
        contentView.addSubview(authorTimeLabel)
        authorTimeLabelConstraints()
    }
    
    func commentLabelConstraints() {
        NSLayoutConstraint.activate([
            commentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            commentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            commentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
    }
    
    func authorTimeLabelConstraints() {
        NSLayoutConstraint.activate([
            authorTimeLabel.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 4),
            authorTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
        ])
    }
}

