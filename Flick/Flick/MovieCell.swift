//
//  MovieCell.swift
//  Flick
//
//  Created by YangSzu Kai on 2017/1/31.
//  Copyright © 2017年 YangSzu Kai. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    @IBOutlet weak var TitleLabel: UILabel!

    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var moviePoster: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
