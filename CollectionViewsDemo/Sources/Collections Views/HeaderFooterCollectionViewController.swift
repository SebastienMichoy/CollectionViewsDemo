//
//  HeaderFooterCollectionViewController.swift
//
//  Copyright © 2015 Sébastien MICHOY and contributors.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer. Redistributions in binary
//  form must reproduce the above copyright notice, this list of conditions and
//  the following disclaimer in the documentation and/or other materials
//  provided with the distribution. Neither the name of the nor the names of
//  its contributors may be used to endorse or promote products derived from
//  this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.

import UIKit

class HeaderFooterCollectionViewController: UIViewController, UICollectionViewDataSource {

    // MARK: - Properties
    @IBOutlet weak var collectionView: UICollectionView!
    let applicationsGroupedByCategory: [ApplicationCategoryItem]
    
    // MARK: - Methods
    // MARK: Init / deinit
    required init(coder aDecoder: NSCoder) {
        self.applicationsGroupedByCategory = ApplicationManager.applicationsGroupedByCategories()
        
        super.init(coder: aDecoder)
    }
    
    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let spacesWidth = deviceType() == .Phone ? 2 : 10 as CGFloat
        
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.minimumLineSpacing = spacesWidth
        collectionViewFlowLayout.minimumInteritemSpacing = spacesWidth
        collectionViewFlowLayout.itemSize = ApplicationIconNameCollectionViewCell.standardSizeForApplicationItem()
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 10, left: spacesWidth, bottom: 5, right: spacesWidth)
        collectionViewFlowLayout.headerReferenceSize = CGSize(width: 0, height: 30)
        collectionViewFlowLayout.footerReferenceSize = CGSize(width: 0, height: 14)
        
        self.collectionView.collectionViewLayout = collectionViewFlowLayout
    }
    
    // MARK: UICollectionViewDataSource protocol
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let application = self.applicationsGroupedByCategory[indexPath.section].applications[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ApplicationIconNameCollectionViewCell", forIndexPath: indexPath) as! ApplicationIconNameCollectionViewCell
        
        cell.fillWithApplicationItem(application)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.applicationsGroupedByCategory[section].applications.count
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let applicationCategory = self.applicationsGroupedByCategory[indexPath.section]
        let supplementaryView: UICollectionReusableView
        
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "ApplicationHeaderCollectionReusableView", forIndexPath: indexPath) as! ApplicationHeaderCollectionReusableView
            header.fillWithApplicationCategoryItem(applicationCategory)
            header.titleLabelLeftInset = deviceType() == .Phone ? 10 : 18
            supplementaryView = header
        } else {
            let footer = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "ApplicationFooterCollectionReusableView", forIndexPath: indexPath) as! ApplicationFooterCollectionReusableView
            footer.fillWithApplicationCategoryItem(applicationCategory)
            supplementaryView = footer
        }
        
        return supplementaryView
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.applicationsGroupedByCategory.count
    }
}
