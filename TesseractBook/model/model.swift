//
//  model.swift
//  TesseractBook
//
//  Created by Kostiantyn Bohonos on 6/11/22.
//

import Foundation





struct book: Codable {
    struct vInfo:Codable {
        struct Identifiers: Codable {
            let type: String
            let identifier: String
        }

        struct imgLinks:Codable {
            let smallThumbnail: String
            let thumbnail: String
        }
        
        let title: String
        let authors: [String]?
        
        let industryIdentifiers: [Identifiers]?
        let imageLinks: imgLinks?
    }
    
    let id: String
    let volumeInfo: vInfo
    
    func inMyLibrary()->Bool{
        Dependencies.myModel.myBooks.contains(book: self)
    }
}



struct books: Codable {
    var items: [book]
    
    mutating func append(_ newbooks:[book]){
        self.items.append(contentsOf: newbooks)
    }
    
    func contains(book b:book)->Bool {
        self.items.contains(where: {$0.id == b.id})
    }
    
    mutating func append(book b:book){
        if self.items.contains(where: {$0.id == b.id}){}else{
            self.items.append(b)
        }
    }
    mutating func remove(book b:book){
        if let fooOffset = self.items.firstIndex(where: {$0.id == b.id}) {
            self.items.remove(at: fooOffset)
        }
    }
    
    mutating func AddDelete(book b:book){
        if contains(book: b){
            remove(book: b)
        }else{
            append(book: b)
        }
    }
}

protocol modelDelegateSearch{
    func UpdateSearchBooks(_ allbooks:books?)
}

protocol modelDelegateLibrary{
    func UpdateLibraryBooks(_ allbooks:books?)
}


class model{
    
    var allBooks:books?
    var myBooks:books = books(items: [])
    
    // Path to library json file in documents directory
    private var PathToFileLibrary:URL = {
        var PathtoFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        PathtoFile = PathtoFile.appendingPathComponent("mybooks")
        PathtoFile = PathtoFile.appendingPathExtension("json")
        return PathtoFile
    }()

    var DelegateSearch:modelDelegateSearch?
    var DelegateLibrary:modelDelegateLibrary?

    var lastsearchtext = ""
    var lastzone:SearchZone = .byTitle
    
    
    var loading = false
    
    // function for the test
    func clearall(){
        self.allBooks =  books(items: [])
        self.myBooks = books(items: [])
        self.lastsearchtext = ""
    }
    
    func AddDeletetoMyBooks(book b:book){
        self.myBooks.AddDelete(book: b)
        self.SaveMyBooks()
        UpdateAllViewList()
    }
    
    // request search in google API
    func RequestBooksList(_ searchtext: String,_ zone:SearchZone){
        self.loading = true
        if self.lastsearchtext != searchtext || self.lastzone != zone {
            self.allBooks = nil
            DelegateSearch?.UpdateSearchBooks(self.allBooks)
        }
        self.lastsearchtext = searchtext
        self.lastzone = zone
        
        let startIndex = self.allBooks != nil ? allBooks!.items.count : 0
        
        APIManager.RequestBooksList(searchtext,lastzone, startIndex) { Res in
            switch Res {
                case .failure(let err):
                    print(err)
                case .success(let data):
                    self.UpdateList(use: data)
            }
            self.loading = false
        }
    }
    
    // Request next 40 book
    func RequestBooksListNext(){
        if !self.loading {
            RequestBooksList(lastsearchtext,lastzone)
        }
    }

    // update list in model and notificate about changes
    private func UpdateList(use data:Data){
        do {
            let Newbooks = try JSONDecoder().decode(books.self, from: data)
            if  self.allBooks != nil {
                self.allBooks?.append(Newbooks.items)
            }else{
                self.allBooks = Newbooks
            }
            DelegateSearch?.UpdateSearchBooks(self.allBooks)
        } catch {
            print("Error data or no new books")
        }
    }
    
    // global notification about update
    func UpdateAllViewList(){
        self.DelegateSearch?.UpdateSearchBooks(self.allBooks)
        self.DelegateLibrary?.UpdateLibraryBooks(self.myBooks)
    }
    
    func UpdateLybraryList(){
        self.DelegateLibrary?.UpdateLibraryBooks(self.myBooks)
    }
    
    func loadMyBooks(){
        let res = JSON.Read(url: self.PathToFileLibrary)
        switch res {
            case .success(let data):
                do {
                    self.myBooks = try JSONDecoder().decode(books.self, from: data)
                } catch {
                    print("error decode json")
                }
            case .failure(let err):
                print(err)
        }
    }
    
    private func SaveMyBooks(){
        JSON.Write(url: self.PathToFileLibrary, with: self.myBooks)
    }
}



