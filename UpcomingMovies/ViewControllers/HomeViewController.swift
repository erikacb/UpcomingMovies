//
//  HomeViewController.swift
//  UpcomingMovies
//
//  Created by Erika Bueno on 06/02/19.
//  Copyright © 2019 8sys. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    // MARK: - Outlets and Variables
    
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var homeTableView: UITableView!
    
    var movies = [Movie]()
    var movie: Movie?
    var nextScreenMovieGenreIds: [Int]?
    let loading = UIActivityIndicatorView(style: .whiteLarge)
    var nextPage = 1
    var totalPages: Int?
    var firstLoad = true
    var searchActive: Bool = false
    var filtered: [Movie] = []
    var genreList = GenreList(genres: [])
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        UISearchController().isActive = false
        self.loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        self.homeTableView.separatorStyle = .none
    }
    
    // MARK: - Load data
    
    @IBAction func reloadData(_ sender: Any) {
        self.reloadButton.isHidden = true
        self.loadData()
    }
    
    func loadData() {
        if NetworkState.isConnected() {
            self.homeTableView.isHidden = false
            self.searchBar.isHidden = false
            if self.firstLoad {
                self.showLoading()
                APIProvider.getGenreList { (results) in
                    self.genreList = results
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
            }
        } else {
            self.reloadButton.isHidden = false
            self.homeTableView.isHidden = true
            self.searchBar.isHidden = true
        }
    }
    
    // MARK: - UITableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchActive {
            return filtered.count
        } else {
            return self.movies.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.homeTableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
        if self.searchActive {
            cell.setup(with: self.filtered[indexPath.row], and: self.genreList)
        } else {
            cell.setup(with: self.movies[indexPath.row], and: self.genreList)
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
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UISearchController().searchBar.resignFirstResponder()
        
        let movieDetails: Movie
        
        if self.searchActive {
            movieDetails = self.filtered[indexPath.row]
        } else {
            movieDetails = self.movies[indexPath.row]
        }
        
        self.nextScreenMovieGenreIds = movieDetails.genreIds ?? []
        
        if NetworkState.isConnected() {
            self.showLoading()
            APIProvider.getMovieDetailsWithCredits(id: movieDetails.id!) { (result) in
                self.movie = result
                self.hideLoading()
                self.performSegue(withIdentifier: "showMovieDetails", sender: self)
            }
        }
    }
    
    // MARK: - Screen Transition
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovieDetails" {
            if let destinationViewController = segue.destination as? MovieViewController {
                destinationViewController.movie = self.movie
                destinationViewController.genreIds = self.nextScreenMovieGenreIds
                destinationViewController.genreList = self.genreList
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
        if searchBar.text != "" {
            self.searchActive = true
        } else {
            self.searchActive = false
            self.homeTableView.reloadData()
        }
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.filtered = []
        self.searchActive = false
        self.homeTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchActive = false
    }
 
}
