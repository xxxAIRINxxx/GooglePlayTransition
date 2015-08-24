//
//  ModalCell.swift
//  GooglePlayTransition
//
//  Created by xxxAIRINxxx on 2015/08/24.
//  Copyright (c) 2015 xxxAIRINxxx. All rights reserved.
//

import UIKit

class ModalCell: UITableViewCell {
    
    @IBOutlet weak var cellImageView : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.cellImageView.layer.cornerRadius = 8.0
    }
}
