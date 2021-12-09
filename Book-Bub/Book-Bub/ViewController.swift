//
//  ViewController.swift
//  Book-Bub
//
//  Created by العــفاف . on 04/05/1443 AH.
//

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
    var imageLinks: ImageLinks
}

struct ImageLinks: Codable {
    var smallThumbnail: String
    var thumbnail: String
}


class ViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BOOKID") as! BookCell
        cell.bookImage.image = arrImages[indexPath.row]
        return cell
    }
    
    @IBOutlet weak var tableView: UITableView!
    var arrImages = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        getBook()
    }
    func getBook(){
        // https://www.googleapis.com/books/v1/volumes?q=swift
        var bookurl = URLComponents()
        bookurl.scheme = "https"
        bookurl.host = "www.googleapis.com"
        bookurl.path = "/books/v1/volumes"
        bookurl.query = "q=harry+potter"
        
        let urlbookRequest = URLRequest(url: bookurl.url!)
        let task = URLSession.shared.dataTask(with: urlbookRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            do {
                if let data = data {
                    let jsomDecoder = JSONDecoder()
                    let result = try jsomDecoder.decode(Response.self, from: data)
                    for item in result.items {
                        self.getImage(item.volumeInfo.imageLinks.thumbnail)
                    }
                    print (result)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func getImage(_ urlString: String) {
        
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { data, _, erroe in
            guard let data = data , erroe == nil else {
                return
            }
            let image = UIImage(data: data)
            self.arrImages.append(image!)
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
            
        }
        task.resume()
    }
    
}

class BookCell: UITableViewCell {
    
    @IBOutlet weak var bookImage: UIImageView!
    
}
