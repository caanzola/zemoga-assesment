//
//  PostTableViewCell.swift
//  zemoga assesment
//
//  Created by Camilo Anzola on 10/26/22.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    var isFav = false
    var selectionCallback: (() -> Void)?
    var removeCallback: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func removePost(_ sender: Any) {
        self.removeCallback?()
    }
    
    @IBAction func starClick(_ sender: Any) {
        isFav = !isFav
        self.selectionCallback?()
    }
}
