//
//  BookDetailViewController.swift
//  TesseractBook
//
//  Created by Kostiantyn Bohonos on 6/11/22.
//

import UIKit

class BookDetailViewController: UIViewController {

    
    @IBOutlet private weak var TitleBook: UILabel!
    @IBOutlet private weak var Authors: UILabel!
    @IBOutlet private weak var ISBN: UILabel!
    @IBOutlet private weak var CoverPhoto: UIImageView!
    @IBOutlet private weak var ActionButton: UIButton!
    
    private var b:book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TitleBook.sizeToFit()
        Authors.sizeToFit()
        self.ActionButton.layer.cornerRadius = 10.0
        self.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func updateView(_ b:book){
        self.b = b
        DispatchQueue.main.async {
            self.refreshView()
        }
    }
    
    func refreshView(){
        self.TitleBook.text = self.b!.volumeInfo.title
        self.Authors.text = self.b!.volumeInfo.authors?.joined(separator: "; ")
        self.ISBN.text = "ISBN: \(self.b!.volumeInfo.industryIdentifiers?[0].identifier ?? "n/a")"
        self.CoverPhoto.load(self.b!,size: .big)
        
        
        if self.b!.inMyLibrary() {
            self.ActionButton.setTitle("remove from library", for: .normal)
            self.ActionButton.backgroundColor = .systemRed
        }else{
            self.ActionButton.setTitle("add to library", for: .normal)
            self.ActionButton.backgroundColor = .systemGreen
        }
        
        
    }
    
    
    @IBAction func ClickAction(_ sender: UIButton) {
        Dependencies.myModel.AddDeletetoMyBooks(book: self.b!)
        DispatchQueue.main.async {
            self.refreshView()
        }
    }
    
    
}
