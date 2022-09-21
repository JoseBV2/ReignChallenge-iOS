//
//  CommentsViewController.swift
//  ReignMobileChallenge
//
//  Created by Jóse Bustamante on 20/09/22.
//

import UIKit

class CommentsViewController: UIViewController {
    
    // MARK: - UI
    
    private let tableView = UITableView()
    let refreshControl = UIRefreshControl()
    
    // MARK: - Properties
    
    var viewModel: CommentsViewProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupViewModel()
        callService()
        fetchNewData()
        configureNavigationBar(largeTitleColor: .black, backgoundColor: .white, tintColor: .white, title: "Comments", preferredLargeTitle: false)
    }
    
    private func setupLayout() {
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CommentsViewCell.self, forCellReuseIdentifier: "CommentsViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableViewConstraints()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        viewModel.getComments()
    }
    
    func tableViewConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupViewModel() {
        viewModel = CommentsViewModel()
        viewModel?.delegate = self
    }
    
    private func callService() {
        viewModel.setCommentsValue()
        viewModel.getComments()
    }
    
    private func fetchNewData() {
        let alert = UIAlertController(title: "Alert", message: "Do you want to fetch new data?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] action in
            self?.viewModel.isAlreadyFetched = false
            self?.viewModel.getComments()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        if UserDefaults.standard.bool(forKey: "isFirstTime") {
            self.present(alert, animated: true, completion: nil)
        } else {
            UserDefaults.standard.set(true, forKey: "isFirstTime")
        }
    }
}

// MARK: - UITableViewDelegate

extension CommentsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: viewModel.getCurrentComment(at: indexPath).storyUrl ?? "https://www.google.com") else { return }
        let vc = WebViewController(url: url, title: viewModel.getCurrentComment(at: indexPath).storyTitle ?? "Default title")
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension CommentsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsViewCell", for: indexPath) as? CommentsViewCell else {
            fatalError("Can't parse")
        }
        cell.selectionStyle = .none
        cell.configure(comments: viewModel.getCurrentComment(at: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            viewModel.removeSpecificComments(at: indexPath)
            
            tableView.endUpdates()
        }
    }
}

// CommentsViewDelegate
extension CommentsViewController: CommentsViewDelegate {
    
    func didRequestSucceded() {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func didFailure(error: Error) {
        refreshControl.endRefreshing()
        viewModel.setCommentsValue()
        tableView.reloadData()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Error loading data", message: "We coudn't fetch the data", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { [weak self] action in
            self?.viewModel.getComments()
            self?.viewModel.isAlreadyFetched = false
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
    
