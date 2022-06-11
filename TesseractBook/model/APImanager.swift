//
//  APImanager.swift
//  TesseractBook
//
//  Created by Kostiantyn Bohonos on 6/11/22.
//

import Foundation
import UIKit

enum RequestErrors: Error{
    case nullSearchText
    case errorCreateUrl
    case noAnswer
}

enum SearchZone:Int{
    case byTitle = 0,byAuthor
    
    var urlstring:String {
        switch self {
        case .byTitle:
            return "intitle:"
        case .byAuthor:
            return "inauthor:"
        }
    }
}


class APIManager{
 
    private static func buildUrl(_ searchtext: String,_ zone:SearchZone,_ startIndex: Int) -> URL? {
        let searchtextEncoded = searchtext.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return URL(string: "https://www.googleapis.com/books/v1/volumes?q=\(zone.urlstring)\(searchtextEncoded!)&startIndex=\(startIndex)&maxResults=40&printType=books")
    }
    
    static func RequestBooksList(_ searchtext: String,_ zone:SearchZone,_ startIndex: Int,_ completion: @escaping(Result<Data,RequestErrors>)->Void){
        guard !searchtext.isEmpty else {
            completion(.failure(.nullSearchText))
            return
        }
        if let url = buildUrl(searchtext,zone,startIndex) {
            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                guard let data = data else {
                    completion(.failure(.noAnswer))
                    return
                }
                completion(.success(data))
            }
            task.resume()
        }else{
            completion(.failure(.errorCreateUrl))
        }
    }
}
