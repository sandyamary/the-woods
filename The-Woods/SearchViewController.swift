//
//  SearchViewController.swift
//  The-Woods
//
//  Created by Udumala, Mary on 3/26/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

import UIKit

// MARK: - SearchViewController

protocol SearchViewControllerDelegate {
    func itemPicker(_ itemPicker: SearchViewController, didPickItem item: TMDBItem?)
}

// MARK: - SearchViewController: UIViewController

class SearchViewController: UIViewController {

    // MARK: Properties
    
    // the data for the table
    var items = [TMDBItem]()
    
    // the delegate will typically be a view controller, waiting for the search to return an item
    var delegate: SearchViewControllerDelegate?
    
    // the most recent data download task. We keep a reference to it so that it can be canceled every time the search text changes
    var searchTask: URLSessionDataTask?
    
    
    @IBOutlet var searchBar: UISearchBar!

    @IBOutlet var searchTableView: UITableView!
    
    override func viewDidLoad() {
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchBar.delegate = self
        // configure tap recognizer
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(_:)))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.delegate = self
        view.addGestureRecognizer(tapRecognizer)
    }
    
    // MARK: Dismissals
    
    func handleSingleTap(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    private func cancel() {
        delegate?.itemPicker(self, didPickItem: nil)
        logout()
    }
    
    func logout() {
        dismiss(animated: true, completion: nil)
    }

}

// MARK: - SearchViewController: UIGestureRecognizerDelegate

extension SearchViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return searchBar.isFirstResponder
    }
}


// MARK: - SearchViewController: UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    // each time the search text changes we want to cancel any current download and start a new one
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // cancel the last task
        if let task = searchTask {
            task.cancel()
        }
        
        // if the text is empty we are done
        if searchText == "" {
            items = [TMDBItem]()
            searchTableView?.reloadData()
            return
        }
        
        // new search
        searchTask = TMDBClient.sharedInstance().getMoviesForSearchString(searchText) { (items, error) in
            self.searchTask = nil
            if let items = items {
                self.items = items
                performUIUpdatesOnMain {
                    self.searchTableView!.reloadData()
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}


// MARK: - SearchViewController: UITableViewDelegate, UITableViewDataSource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CellReuseId = "ItemSearchCell"
        let item = items[(indexPath as NSIndexPath).row]
        print("THE ITEM\n: \(item)")
        let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseId) as UITableViewCell!
        
        if let releaseYear = item.releaseYear {
            cell?.textLabel!.text = "\(item.title) (\(releaseYear))"
        } else {
            cell?.textLabel!.text = "\(item.title)"
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of Items: \(items.count)")
        return items.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[(indexPath as NSIndexPath).row]
        let controller = storyboard!.instantiateViewController(withIdentifier: "ItemDetailViewController") as! ItemDetailViewController
        controller.item = item
        navigationController!.pushViewController(controller, animated: true)
    }
}



