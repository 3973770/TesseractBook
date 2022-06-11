//
//  ViewController.swift
//  TesseractBook
//
//  Created by Kostiantyn Bohonos on 6/11/22.
//

import UIKit


class ViewController: UIViewController {
    
    private var allbooks:books?
    private var timerStartSearch: Timer?
    
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var SearchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.register(BookTableViewCell.self, forCellReuseIdentifier: BookTableViewCell.Identifier)
        Dependencies.myModel.DelegateSearch = self
        SearchBar.text = ""
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        StartSearch()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        StartSearch()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchBar.resignFirstResponder()
        StartSearch()
    }
    
    func StartSearch(){
        if let timerStartSearch =  self.timerStartSearch {
            timerStartSearch.invalidate()
        }
        self.timerStartSearch = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { timer in
            timer.invalidate()
            Dependencies.myModel.RequestBooksList(self.SearchBar.text!, SearchZone.init(rawValue: self.SearchBar.selectedScopeButtonIndex)!)
        }
    }
}


extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // use reusable Table view cell
        guard let cell:BookTableViewCell = tableView.dequeueReusableCell(withIdentifier:BookTableViewCell.Identifier , for: indexPath)  as? BookTableViewCell else {return UITableViewCell()}
        if let displaybook = self.allbooks?.items[indexPath.row] {
            cell.configure(book: displaybook)
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{1}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let allbooks = allbooks else { return 0}
        return allbooks.items.count
    }
}

extension ViewController: UITableViewDataSourcePrefetching{
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let allbooks = self.allbooks else { return }
        
        var maxpos = 0
        for ip in indexPaths {
            maxpos = maxpos < ip.row ? ip.row : maxpos
        }
        // almost at the end of the list of books,  we try to obtain from google API the next 40 books
        if (allbooks.items.count-maxpos) < 5 {
            // send same request but with new start index
            Dependencies.myModel.RequestBooksListNext()
        }
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        guard let allbooks = self.allbooks else { return }
        
        let Storyboard  = UIStoryboard(name: "Main", bundle: nil)
        let DetailView: BookDetailViewController = Storyboard.instantiateViewController(withIdentifier: "DetailView") as! BookDetailViewController
        DetailView.updateView(allbooks.items[indexPath.row])
        self.showDetailViewController(DetailView, sender: self)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
            -> UISwipeActionsConfiguration? {
            guard let allbooks = self.allbooks else { return nil }
            
                let action = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
                    Dependencies.myModel.AddDeletetoMyBooks(book: allbooks.items[indexPath.row])
                    completionHandler(true)
                }
                
                if allbooks.items[indexPath.row].inMyLibrary() {
                    action.image = UIImage(systemName: "trash")
                    action.backgroundColor = .systemRed
                }else{
                    action.image = UIImage(systemName: "heart.fill")
                    action.backgroundColor = .systemGreen
                }
            let configuration = UISwipeActionsConfiguration(actions: [action])
            return configuration
    }
}

extension ViewController: modelDelegateSearch{
    func UpdateSearchBooks(_ allbooks: books?) {
        self.allbooks = allbooks
        DispatchQueue.main.async {
            self.TableView.reloadData()
        }
    }
}
