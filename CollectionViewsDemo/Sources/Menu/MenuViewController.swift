//
//  MenuViewController.swift
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

class MenuViewController: UIViewController {
    
    // MARK: Properties
    
    private var collapseDetailViewController: Bool
    private var lastIndexPathSelected: NSIndexPath
    private let menuItems: [MenuItem]
    @IBOutlet private var tableView: UITableView!
    
    // MARK: Initialization
    
    required init?(coder aDecoder: NSCoder) {
        self.collapseDetailViewController = true
        self.lastIndexPathSelected = NSIndexPath(forRow: 0, inSection: 0)
        self.menuItems = MenuManager.menuItemsList()
        
        super.init(coder: aDecoder)
    }
    
    // MARK: View Life Cycle
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if deviceType() == .Pad || (deviceModel() == .iPhone6Plus && (deviceOrientation() == .LandscapeLeft || deviceOrientation() == .LandscapeRight))  {
            self.tableView.selectRowAtIndexPath(self.lastIndexPathSelected, animated: false, scrollPosition: .Top)
        } else {
            self.tableView.deselectRowAtIndexPath(self.lastIndexPathSelected, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.splitViewController?.delegate = self
    }
    
    // MARK: Rotation
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        let animation: (UIViewControllerTransitionCoordinatorContext!) -> Void = { context in
            if deviceModel() == .iPhone6Plus && (deviceOrientation() == .LandscapeLeft || deviceOrientation() == .LandscapeRight) {
                self.tableView.selectRowAtIndexPath(self.lastIndexPathSelected, animated: false, scrollPosition: .Top)
            }
        }
        
        let completion: (UIViewControllerTransitionCoordinatorContext!) -> Void = { context in
        }
        
        coordinator.animateAlongsideTransition(animation, completion: completion)
        
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
}

extension MenuViewController: UISplitViewControllerDelegate {

    // MARK: UISplitViewControllerDelegate Protocol
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return self.collapseDetailViewController
    }
}

extension MenuViewController: UITableViewDataSource {

    // MARK: UITableViewDataSource Protocol
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let menuItem = self.menuItems[indexPath.row]
        
        cell.textLabel?.text = menuItem.title
        cell.detailTextLabel?.text = menuItem.subtitle
        cell.selectionStyle = .Default
        
        if deviceType() == .Phone {
            cell.accessoryType = .DisclosureIndicator
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItems.count
    }
}

extension MenuViewController: UITableViewDelegate {

    // MARK: UITableViewDelegate Protocol
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let menuItem = self.menuItems[indexPath.row]
        let storyboard = UIStoryboard(name: "CollectionViewsDemo", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier(menuItem.storyboardId) 
        let navigationController = UINavigationController(rootViewController: viewController)
        
        if let splitViewController = self.splitViewController {
            self.collapseDetailViewController = false
            self.lastIndexPathSelected = indexPath
            
            viewController.title = menuItem.title
            viewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
            viewController.navigationItem.leftItemsSupplementBackButton = true
            
            splitViewController.showDetailViewController(navigationController, sender: self)
        }
    }
}
