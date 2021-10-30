//
//  ViewController.swift
//  MovieDB
//
//  Created by Amit Samant on 30/10/21.
//

import UIKit

class MovieListVC: UITableViewController {
    
    let viewModel: MovieListViewModel

    
    init(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
        super.init(style: .plain)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        switch viewModel.type {
        case .popular:
            self.title = "Popular"
            self.tabBarItem = .init(tabBarSystemItem: .favorites, tag: 0)
        case .trending:
            self.title = "Trending"
            self.tabBarItem = .init(tabBarSystemItem: .featured, tag: 0)
        }
        configureTable()
        reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    func configureTable() {
        tableView.register(
            MovieCell.self,
            forCellReuseIdentifier: MovieCell.reuseIdentifier
        )
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadData(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    

    @objc func reloadData(_ sender: UIRefreshControl? = nil) {
        viewModel.fetch { [weak self] in
            self?.tableView.reloadData()
            sender?.endRefreshing()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movieCell = MovieCell(style: .default, reuseIdentifier: MovieCell.reuseIdentifier)
        let result = viewModel.results[indexPath.row]
        movieCell.titleLabel.text = result.title
        movieCell.subTitleLabel.text = result.mediaType
        movieCell.descriptionLabel.text = result.overview
        guard let url = result.imageURL else {
            return movieCell
        }
        viewModel.loadImage(forUrl: url) { image in
            movieCell.resultImageView.image = image
            movieCell.setNeedsLayout()
        }
        return movieCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < viewModel.results.count else {
            return
        }
        let movie = viewModel.results[indexPath.row]
        let movieDetailVC = MovieDetailVC(movie: movie)
        navigationController?.pushViewController(movieDetailVC, animated: true)
    }
}

