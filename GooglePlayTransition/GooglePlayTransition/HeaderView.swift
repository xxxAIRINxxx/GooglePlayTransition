//
//  HeaderView.swift
//  GooglePlayTransition
//
//  Created by xxxAIRINxxx on 2015/08/24.
//  Copyright (c) 2015 xxxAIRINxxx. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    
    var tapButtonHandler : (Void -> Void)?
   
    @IBOutlet weak var imageView : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func tapBackButton() {
        self.tapButtonHandler?()
    }
}
