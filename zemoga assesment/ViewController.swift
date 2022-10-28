//
//  ViewController.swift
//  zemoga assesment
//
//  Created by Camilo Anzola on 10/24/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIImageView!
    var posts: [Post]? = []
    var favPosts: [Post] = []
    var comments: [Comment]?
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var authorResponse : Author?
    @IBOutlet weak var removeAllButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingIndicator.isHidden = true
        self.tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        self.removeAllButton.isHidden = true
    }
    
    @IBAction func loadData(_ sender: Any) {
        self.loadingIndicator.isHidden = false
        self.loadingIndicator.startAnimating()
        self.favPosts.removeAll()
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        URLSession.shared.fetchPosts(at: url) { result in
          switch result {
              case .success(let posts):
                  self.posts = posts
                  DispatchQueue.main.async {
                      self.emptyView.isHidden = (self.posts != nil)
                      self.loadingIndicator.isHidden = true
                      self.tableView.isHidden = false
                      self.removeAllButton.isHidden = false
                      self.tableView.reloadData()
                  }
              case .failure(let error):
                  DispatchQueue.main.async {
                      let dialogMessage = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                      self.present(dialogMessage, animated: true, completion: nil)
                  }
          }
        }
    }
    
    func loadAuthor(idAuthor: Int){
        let url = URL(string: "https://jsonplaceholder.typicode.com/users/\(idAuthor)")!
        URLSession.shared.fetchUsers(at: url) { result in
          switch result {
              case .success(let author):
                  self.authorResponse = author
                  break
              case .failure(let error):
                  DispatchQueue.main.async {
                      let dialogMessage = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                      self.present(dialogMessage, animated: true, completion: nil)
                  }
          }
        }
    }
    
    func loadComments(postId: Int){
        let url = URL(string: "https://jsonplaceholder.typicode.com/comments?postId=\(postId)")!
        URLSession.shared.fetchComments(at: url) { result in
          switch result {
              case .success(let comments):
                  self.comments = comments
              case .failure(let error):
                  DispatchQueue.main.async {
                      let dialogMessage = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                      self.present(dialogMessage, animated: true, completion: nil)
                  }
          }
        }
    }
    
    @IBAction func removeAll(_ sender: Any) {
        self.posts?.removeAll()
        self.tableView.reloadData()
        if self.favPosts.isEmpty {
            self.emptyView.isHidden = false
            self.tableView.isHidden = true
            self.removeAllButton.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! PostTableViewCell
        if indexPath.section == 0 {
            cell.title.text = favPosts[indexPath.row].title
            cell.starButton.setImage(UIImage(named: "fav"), for: .normal)
            cell.removeButton.isHidden = true
            cell.isFav = true
        } else {
            cell.title.text = posts?[indexPath.row].title
            cell.starButton.setImage(UIImage(named: "star"), for: .normal)
            cell.removeButton.isHidden = false
            cell.isFav = false
        }
        
        cell.selectionCallback = { [self] in
            if cell.isFav {
                self.favPosts.append((posts?[indexPath.row])!)
                self.posts?.remove(at: indexPath.row)
            } else {
                self.posts?.insert((favPosts[indexPath.row]), at: indexPath.row)
                self.favPosts.remove(at: indexPath.row)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        cell.removeCallback = { [self] in
            self.posts?.remove(at: indexPath.row)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return CGFloat(100)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
           return 2
    }
    
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return favPosts.count
        }
        else {
            return posts?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            if section == 0 {
                let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 100))
                let titleLabel = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width - 15, height: 80))
                titleLabel.textColor = .black
                titleLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
                titleLabel.frame = CGRect(x: 30, y: -7, width: tableView.frame.size.width, height: 35)
                if self.favPosts.isEmpty {
                    titleLabel.text = "Your favorites list is empty"
                }
                view.addSubview(titleLabel)
                return view
            } else {
                return nil
            }
    }
    
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post: Post?
        if indexPath.section == 0 {
            post = self.favPosts[indexPath.row]
        } else {
            post = self.posts?[indexPath.row]
        }
        self.loadAuthor(idAuthor: post!.userId )
        self.loadComments(postId: post!.id)
        let VC = self.storyboard!.instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController
        VC.setInfo(title: post?.title, description: post!.body)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            VC.setAuthorInfo(author: self.authorResponse!)
            VC.setComments(comments: self.comments)
        }
        self.navigationController?.pushViewController(VC, animated: false)
    }
}

struct Post: Decodable {
  let userId: Int
  let id: Int
  let title: String
  let body: String
}

struct Author: Decodable {
  let name: String
  let email: String
  let phone: String
  let website: String
}

struct Comment: Decodable {
    let name: String
    let body: String
    let email: String
}

extension URLSession {
  func fetchPosts(at url: URL, completion: @escaping (Result<[Post], Error>) -> Void) {
    self.dataTask(with: url) { (data, response, error) in
      if let error = error {
        completion(.failure(error))
      }

      if let data = data {
        do {
          let posts = try JSONDecoder().decode([Post].self, from: data)
          completion(.success(posts))
        } catch let decoderError {
          completion(.failure(decoderError))
        }
      }
    }.resume()
  }
    
    func fetchUsers(at url: URL, completion: @escaping (Result<Author, Error>) -> Void) {
      self.dataTask(with: url) { (data, response, error) in
        if let error = error {
          completion(.failure(error))
        }

        if let data = data {
          do {
            let users = try JSONDecoder().decode(Author.self, from: data)
            completion(.success(users))
              
          } catch let decoderError {
            completion(.failure(decoderError))
          }
        }
      }.resume()
    }
    
    func fetchComments(at url: URL, completion: @escaping (Result<[Comment], Error>) -> Void) {
      self.dataTask(with: url) { (data, response, error) in
        if let error = error {
          completion(.failure(error))
        }

        if let data = data {
          do {
              let users = try JSONDecoder().decode([Comment].self, from: data)
            completion(.success(users))
              
          } catch let decoderError {
            completion(.failure(decoderError))
          }
        }
      }.resume()
    }
}

