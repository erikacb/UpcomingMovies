//
//  HomeViewController.swift
//  UpcomingMovies
//
//  Created by Erika Bueno on 06/02/19.
//  Copyright © 2019 8sys. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var homeTableView: UITableView!
    var movies = [Movie]()
    let loading = UIActivityIndicatorView(style: .whiteLarge)
    var nextPage = 1
    var totalPages: Int?
    var firstLoad = true
    
    override func viewWillAppear(_ animated: Bool) {
        
        if NetworkState.isConnected() {
            if self.firstLoad {
                self.showLoading()
                APIProvider.getUpcomingMovies(page: 1) { (results) in
                    self.firstLoad = false
                    self.movies = results.results ?? []
                    self.totalPages = results.totalPages
                    if self.totalPages! > 1 && self.movies.count > 0 {
                        self.nextPage += 1
                    }
                    DispatchQueue.main.async {
                        self.homeTableView.reloadData()
                    }
                    self.hideLoading()
                }
            }
        } else {
            print("Device is not connected!")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        self.homeTableView.separatorStyle = .none
        
    }
    
    // MARK: - UITableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.homeTableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
        cell.setup(with: self.movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (self.movies.count - 1 == indexPath.row) && (self.nextPage < self.totalPages!) {
            
            if NetworkState.isConnected() {
                self.showLoading()
                print("CURRENT PAGE TO BE LOADED: \(self.nextPage)")
                APIProvider.getUpcomingMovies(page: self.nextPage) { (newResults) in
                    print("MOVIES BEFORE: \(self.movies.count)")
                    print("FIRST MOVIE BEFORE: \(self.movies.first?.title ?? "No title available")")
                    print("LAST MOVIE BEFORE: \(self.movies.last?.title ?? "No title available")")
                    print("FIRST MOVIE THAT WILL BE ADDED: \(newResults.results?.first?.title ?? "No title available")")
                    print("LAST MOVIE THAT WILL BE ADDED: \(newResults.results?.last?.title ?? "No title available")")
                    self.movies += newResults.results ?? []
                    print("MOVIES AFTER: \(self.movies.count)")
                    print("FIRST MOVIE AFTER: \(self.movies.first?.title ?? "No title available")")
                    print("LAST MOVIE AFTER: \(self.movies.last?.title ?? "No title available")")
                    DispatchQueue.main.async {
                        self.homeTableView.reloadData()
                    }
                    if newResults.totalPages! > 1 && self.nextPage < newResults.totalPages! && self.movies.count > 0 {
                        self.nextPage += 1
                        print("NEXT PAGE TO BE LOADED: \(self.nextPage)")
                    }
                    self.hideLoading()
                }
            } else {
                print("Device is not connected!")
            }
            
        }
    }
    
    // MARK: - UIView Helpers
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        DispatchQueue.main.async {
            self.homeTableView.reloadData()
        }
    }
    
    func showLoading() {
        self.loading.center = self.view.center
        self.loading.frame = self.view.bounds
        self.loading.startAnimating()
        self.view.addSubview(self.loading)
    }
    
    func hideLoading() {
        self.loading.removeFromSuperview()
    }
    
}
