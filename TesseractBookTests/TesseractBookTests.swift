//
//  TesseractBookTests.swift
//  TesseractBookTests
//
//  Created by Kostiantyn Bohonos on 6/11/22.
//

import XCTest

class TesseractBookTests: XCTestCase {

    enum TestErrows:Error{
        case ListOfBooksIsEmpty
        case ListOfmyBooksIsEmpty
        
    }
    
    
    let searchtext: String = "harry+potter"
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testAPI_Get40BooksPerOneRequest_byAuthor() throws {
        Dependencies.myModel.RequestBooksList(searchtext, .byAuthor)
        if let allBooks = Dependencies.myModel.allBooks {
            XCTAssertEqual(allBooks.items.count, 40)
        }
        
    }
    func testAPI_Get40BooksPerOneRequest_byTitle() throws {
        Dependencies.myModel.RequestBooksList(searchtext, .byTitle)
        if let allBooks = Dependencies.myModel.allBooks {
            XCTAssertEqual(allBooks.items.count, 40)
        }
    }
    

    func testAPI_Get200Books_Harry_Potter() throws {
        Dependencies.myModel.clearall()
        Dependencies.myModel.RequestBooksList(searchtext, .byTitle)
        for _ in 1...5 {
            Dependencies.myModel.RequestBooksListNext()
            sleep(1)
        }
        if let allBooks = Dependencies.myModel.allBooks {
            XCTAssertEqual(allBooks.items.count, 200)
        }
    }
    
    func test_myLibrary_add_5_book() throws {
        Dependencies.myModel.clearall()
        Dependencies.myModel.RequestBooksList(searchtext, .byTitle)
        sleep(1)
        guard let allBooks = Dependencies.myModel.allBooks else { throw TestErrows.ListOfBooksIsEmpty}
        
        for i in 10..<15 {
            Dependencies.myModel.AddDeletetoMyBooks(book: allBooks.items[i])
        }
        XCTAssertEqual(Dependencies.myModel.myBooks.items.count, 5)
    }
    
    func test_myLibrary_add_and_delete_5_book() throws {
        Dependencies.myModel.clearall()
        Dependencies.myModel.RequestBooksList(searchtext, .byTitle)
        sleep(1)
        guard let allBooks = Dependencies.myModel.allBooks else { throw TestErrows.ListOfBooksIsEmpty}
        
        for i in 10..<15 {
            Dependencies.myModel.AddDeletetoMyBooks(book: allBooks.items[i])
        }
        for i in 10..<15 {
            Dependencies.myModel.AddDeletetoMyBooks(book: allBooks.items[i])
        }
        XCTAssertEqual(Dependencies.myModel.myBooks.items.count, 0)
    }
    
    
    
    
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
