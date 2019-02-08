//
//  HomeViewController.swift
//  UpcomingMovies
//
//  Created by Erika Bueno on 06/02/19.
//  Copyright © 2019 8sys. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var homeTableView: UITableView!
    var movies = [Movie]()
    var movie: Movie?
    let loading = UIActivityIndicatorView(style: .whiteLarge)
    var nextPage = 1
    var totalPages: Int?
    var firstLoad = true
    var searchActive: Bool = false
    var filtered: [Movie] = []
    
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
        if self.searchActive {
            return filtered.count
        }
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.homeTableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
        
        if self.searchActive {
            cell.setup(with: self.filtered[indexPath.row])
        } else {
            cell.setup(with: self.movies[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (self.movies.count - 1 == indexPath.row) && (self.nextPage < self.totalPages!) {
            
            if NetworkState.isConnected() {
                self.showLoading()
                APIProvider.getUpcomingMovies(page: self.nextPage) { (newResults) in
                    self.movies += newResults.results ?? []
                    DispatchQueue.main.async {
                        self.homeTableView.reloadData()
                    }
                    if newResults.totalPages! > 1 && self.nextPage < newResults.totalPages! && self.movies.count > 0 {
                        self.nextPage += 1
                    }
                    self.hideLoading()
                }
            } else {
                print("Device is not connected!")
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let movieDetails: Movie
        
        if self.searchActive {
            movieDetails = self.filtered[indexPath.row]
        } else {
            movieDetails = self.movies[indexPath.row]
        }
        
        if NetworkState.isConnected() {
            self.showLoading()
            APIProvider.getMovieDetailsWithCredits(id: movieDetails.id!) { (result) in
                self.movie = result
                self.hideLoading()
                self.performSegue(withIdentifier: "showMovieDetails", sender: self)
            }
        }
    }
    
    // MARK: - Screen transition
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovieDetails" {
            if let destinationViewController = segue.destination as? MovieViewController {
                destinationViewController.movie = self.movie
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
    
    // MARK: - Search Helpers
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        self.filtered = self.movies.filter({ (text) -> Bool in
            let tmp: NSString = text.title! as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        
        if self.filtered.count == 0 {
            self.searchActive = false
        } else {
            self.searchActive = true
        }
        
        self.homeTableView.reloadData()
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchActive = false
    }
}
