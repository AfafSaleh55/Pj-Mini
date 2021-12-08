//
//  ViewController.swift
//  Book-Bub
//
//  Created by العــفاف . on 04/05/1443 AH.
//
//Create  3 struct for Response, VolumeInfo ,VolumeInfo
//creat funcion getBook()
import UIKit

struct Response : Codable {
  var kind: String
  var totalItems: Int
  var items: [VolumeInfo]
}
//volumeInfo

struct VolumeInfo: Codable {
  var volumeInfo: Book
}

struct Book: Codable {
  var title: String
  var authors: [String]
}

class ViewController : UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    getBook()
  }
  func getBook(){
    // https://www.googleapis.com/books/v1/volumes?q=swift
    var bookurl = URLComponents()
    bookurl.scheme = "https"
    bookurl.host = "www.googleapis.com"
    bookurl.path = "/books/v1/volumes"
    bookurl.query = "q=swift"

    let urlbookRequest = URLRequest(url: bookurl.url!)
    let task = URLSession.shared.dataTask(with: urlbookRequest) { (data: Data?, response: URLResponse?, error: Error?) in
      do {
        let jsomDecoder = JSONDecoder()
        let result = try jsomDecoder.decode(Response.self, from: data!)
        print (result)
      } catch {
        print(error)
      }
    }
    task.resume()
  }
}
