//
//  json.swift
//  TesseractBook
//
//  Created by Kostiantyn Bohonos on 6/12/22.
//

import Foundation

enum ErrorJson:Error{
    case FileNotFound
    case ErrorReading
}

class JSON {
    static func Read(url fileurl:URL) -> Result<Data,Error> {
        if FileManager.default.fileExists(atPath: fileurl.path) {
            do {
                let data = try Data(contentsOf: fileurl)
                return .success(data)
            } catch {
                return .failure(ErrorJson.ErrorReading)
            }
        }
        return .failure(ErrorJson.FileNotFound)
    }
    
    static func Write<T:Encodable>(url fileurl:URL,with object:T){
        if let data = try? JSONEncoder().encode(object) {
            if FileManager.default.fileExists(atPath: fileurl.path) {
                try? data.write(to: fileurl)
              } else {
                  FileManager.default.createFile(atPath: fileurl.path, contents: data, attributes: nil)
              }
        }
    }
}
