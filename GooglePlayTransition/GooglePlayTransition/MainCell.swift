//
//  MainCell.swift
//  GooglePlayTransition
//
//  Created by xxxAIRINxxx on 2015/08/22.
//  Copyright (c) 2015 xxxAIRINxxx. All rights reserved.
//

import UIKit

class MainCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImageView : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.cellImageView.layer.cornerRadius = 8.0
    }
}
