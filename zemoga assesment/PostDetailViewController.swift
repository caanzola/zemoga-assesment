//
//  PostDetailViewController.swift
//  zemoga assesment
//
//  Created by Camilo Anzola on 10/26/22.
//

import UIKit

class PostDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var strTitle: String?
    var strDscrptn: String?
    var strAuthName: String?
    var strAuthEmail: String?
    var strAuthPhone: String?
    var strAuthWebsite: String?
    var comments: [Comment]?

    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postDescription: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var authorEmail: UILabel!
    @IBOutlet weak var authorPhone: UILabel!
    @IBOutlet weak var authorWebpage: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postTitle.text = strTitle
        self.postDescription.text = strDscrptn
        authorName.text = strAuthName
        authorEmail.text = strAuthEmail
        authorPhone.text = strAuthPhone
        authorWebpage.text = strAuthWebsite
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setInfo(title: String?, description: String?) {
        self.strTitle = title
        self.strDscrptn = description
    }
    
    func setAuthorInfo(author: Author){
        strAuthName = author.name
        strAuthEmail = author.email
        strAuthPhone = author.phone
        strAuthWebsite = author.website
        authorName.text = strAuthName
        authorEmail.text = strAuthEmail
        authorPhone.text = strAuthPhone
        authorWebpage.text = strAuthWebsite
    }
    
    func setComments(comments: [Comment]?){
        self.comments = comments
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "comment", for: indexPath) as! CommentTableViewCell
        cell.name.text = comments?[indexPath.row].name
        return cell
    }
    
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return CGFloat(80)
    }
}
