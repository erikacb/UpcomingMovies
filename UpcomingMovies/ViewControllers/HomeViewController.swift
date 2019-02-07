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

    override func viewWillAppear(_ animated: Bool) {
        self.showLoading()
        APIProvider.getUpcomingMovies(page: 1) { (results) in
            self.movies = results.results ?? []
            DispatchQueue.main.async {
                self.homeTableView.reloadData()
            }
            self.hideLoading()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        self.homeTableView.separatorStyle = .none
        
        // Testing... \o/
        
        APIProvider.getMovieDetailsWithCredits(id: 522681) { (results) in
            print("SINGLE MOVIE")
            print("Title: \(results.title ?? "No title")")
            print("Id: \(results.id ?? 0)")
            print("Gender Ids: \(results.genres ?? [])")
        }
        
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
