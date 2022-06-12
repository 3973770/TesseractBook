//
//  LibraryViewController.swift
//  TesseractBook
//
//  Created by Kostiantyn Bohonos on 6/11/22.
//

import UIKit

class LibraryViewController: UIViewController {
    private var allbooks:books?
    @IBOutlet weak var TableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.register(BookTableViewCell.self, forCellReuseIdentifier: BookTableViewCell.Identifier)
        Dependencies.myModel.DelegateLibrary = self
        Dependencies.myModel.UpdateAllViewList()
    }
}


extension LibraryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "My library"
    }
}

extension LibraryViewController: UITableViewDelegate {
    
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
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
                guard let allbooks = self.allbooks else { return }
                self.allbooks?.items.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.bottom)
                Dependencies.myModel.AddDeletetoMyBooks(book: allbooks.items[indexPath.row])
                completionHandler(true)
            }
            deleteAction.image = UIImage(systemName: "trash")
            deleteAction.backgroundColor = .systemRed
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
    }
}

extension LibraryViewController: modelDelegateLibrary{
    func UpdateLibraryBooks(_ allbooks: books?) {
        self.allbooks = allbooks
        DispatchQueue.main.async {
            self.TableView.reloadData()
        }
    }
}
