
//
//  BookTableViewCell.swift
//  TesseractBook
//
//  Created by Kostiantyn Bohonos on 6/11/22.
//

import UIKit

class BookTableViewCell: UITableViewCell {

    static let Identifier = "bookcell"
    var CoverImage:UIImageView  = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "books.vertical")?.withTintColor(.systemGray2, renderingMode: .alwaysOriginal)
        iv.frame = CGRect(x: 0, y: 0, width: 84, height: 84)
        iv.translatesAutoresizingMaskIntoConstraints = false;
        return iv
    }()
    var TitleBook:UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 2
        lbl.translatesAutoresizingMaskIntoConstraints = false;
        return lbl
    }()
    var Authors:UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.font = UIFont.italicSystemFont(ofSize: 14)
        lbl.textAlignment = .left
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 2
        lbl.translatesAutoresizingMaskIntoConstraints = false;
        return lbl
    }()
    var InMyLib: UIImageView = {
        let iv = UIImageView()
        iv.alpha = 0
        iv.image = UIImage(systemName: "heart.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        iv.translatesAutoresizingMaskIntoConstraints = false;
        return iv
    }()
    private var b:book?

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.translatesAutoresizingMaskIntoConstraints = false;
        contentView.addSubview(CoverImage)
        contentView.addSubview(InMyLib)
        contentView.addSubview(TitleBook)
        contentView.addSubview(Authors)
        
        TitleBook.sizeToFit()
        Authors.sizeToFit()
        
 

        NSLayoutConstraint.activate([
            CoverImage.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            CoverImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            CoverImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            CoverImage.widthAnchor.constraint(equalToConstant: 84),
            CoverImage.heightAnchor.constraint(equalToConstant: 84),
            InMyLib.topAnchor.constraint(equalTo: topAnchor),
            InMyLib.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            InMyLib.widthAnchor.constraint(equalToConstant: 20),
            InMyLib.heightAnchor.constraint(equalToConstant: 20),
            TitleBook.topAnchor.constraint(equalTo: topAnchor),
            TitleBook.leadingAnchor.constraint(equalTo: CoverImage.trailingAnchor, constant: 10),
            TitleBook.trailingAnchor.constraint(equalTo: InMyLib.leadingAnchor, constant: -5),
            Authors.topAnchor.constraint(equalTo: TitleBook.bottomAnchor, constant: 5),
            Authors.leadingAnchor.constraint(equalTo: TitleBook.leadingAnchor),
            Authors.trailingAnchor.constraint(equalTo: InMyLib.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(book b:book){
        self.b = b
        DispatchQueue.main.async {
            self.refreshView()
        }
    }
    
    
    func refreshView(){
        self.InMyLib.alpha = 0
        if self.b!.inMyLibrary() {
            self.InMyLib.alpha = 1
        }
        self.TitleBook.text = self.b!.volumeInfo.title
        self.Authors.text = self.b!.volumeInfo.authors?.joined(separator: "; ")
        self.CoverImage.load(self.b!,size: .small)
    }
    
    func UpdateImage(){
        self.CoverImage.load(self.b!,size: .small)
    }
}
