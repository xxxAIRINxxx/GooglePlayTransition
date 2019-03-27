//
//  ViewController.swift
//  GooglePlayTransition
//
//  Created by xxxAIRINxxx on 2015/08/22.
//  Copyright (c) 2015 xxxAIRINxxx. All rights reserved.
//

import UIKit
import ARNTransitionAnimator

final class ViewController: UIViewController, GooglePlayTransitionInterface, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView : UICollectionView!
    
    weak var selectedImageView : UIImageView?

    private var animator : ARNTransitionAnimator!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flowLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        flowLayout.itemSize = CGSize(width: 90, height: 90)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        self.collectionView.collectionViewLayout = flowLayout
        
        self.collectionView.register(UINib(nibName: "MainCell", bundle: nil), forCellWithReuseIdentifier: "MainCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ViewController viewWillAppear")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animator = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("ViewController viewWillDisappear")
    }
    
    // MARK: - GooglePlayTransitionInterface
    
    func createTransitionImageView() -> UIImageView {
        let imageView = UIImageView(image: self.selectedImageView!.image)
        imageView.contentMode = self.selectedImageView!.contentMode
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = false
        imageView.layer.cornerRadius = self.selectedImageView!.layer.cornerRadius
        imageView.frame = self.selectedImageView!.convert(self.selectedImageView!.frame, to: self.view)
        
        return imageView
    }

    func presentationBeforeAction() {
        self.selectedImageView?.isHidden = true
    }

    func dismissalCompletionAction(_ completeTransition: Bool) {
        self.selectedImageView?.isHidden = false
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCell", for: indexPath as IndexPath) as! MainCell
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath as IndexPath) as! MainCell
        self.selectedImageView = cell.cellImageView
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ModalViewController") as! ModalViewController

        let animation = GooglePlayTransitionAnimation(rootVC: self, modalVC: controller)
        self.animator = ARNTransitionAnimator(duration: 0.8, animation: animation)
        controller.transitioningDelegate = self.animator

        self.present(controller, animated: true, completion: nil)
    }
}

