    //
    //  MasterViewController.swift
    //  Papers
    //
    //  Created by Tim Mitra on 1/14/16.
    //  Copyright © 2016 Razeware LLC. All rights reserved.
    //

    import UIKit


    class MasterViewController: UICollectionViewController {

    @IBOutlet weak var addButton: UIBarButtonItem!

    private var papersDataSource = PapersDataSource()
    private let reuseIdentifier = "PaperCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
      navigationItem.leftBarButtonItem = editButtonItem()
      navigationController?.toolbarHidden = true
        
      let width = CGRectGetWidth(collectionView!.frame) / 3
      let layout = collectionViewLayout as! UICollectionViewFlowLayout
      layout.itemSize = CGSize(width: width, height: width)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        addButton.enabled = !editing
        collectionView!.allowsMultipleSelection = editing
        let indexPaths = collectionView!.indexPathsForVisibleItems() as [NSIndexPath]
        
        for indexPath in indexPaths {
            collectionView!.deselectItemAtIndexPath(indexPath, animated: false)
            let cell = collectionView!.cellForItemAtIndexPath(indexPath) as! PaperCell
            cell.editing = editing
        }
        if !editing {
            navigationController?.setToolbarHidden(true, animated: animated)
        }
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //  override func prepareForSegue(segue: UIStoryboardSegue, sender:
    //    AnyObject?) {
    //      if segue.identifier == "MasterToDetail" {
    //        if let indexPath = collectionView!.indexPathsForSelectedItems()!.first {
    //            if let paper = papersDataSource.paperForItemAtIndexPath(indexPath) {
    //                let detailViewController = segue.destinationViewController as! DetailViewController
    //                detailViewController.paper = paper
    //            }
    //        }
    //      }
    //  }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if segue.identifier == "MasterToDetail" {
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.paper = sender as? Paper
      }
    }

    // MARK: MasterViewController

    @IBAction func addButtonTapped(sender: UIBarButtonItem) {

    let indexPath = papersDataSource.indexPathForNewRandomPaper()
    let layout = collectionViewLayout as! PapersFlowLayout
    layout.appearingIndexPath = indexPath

    UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
      
      self.collectionView!.insertItemsAtIndexPaths([indexPath])

      }, completion: { (finished: Bool) -> Void in
        layout.appearingIndexPath = nil
    })

    }
    
    @IBAction func deleteButtonTapped(sender: UIBarButtonItem) {
        let indexPaths = collectionView!.indexPathsForSelectedItems()! as [NSIndexPath]
        papersDataSource.deleteItemsAtIndexPaths(indexPaths)
        collectionView!.deleteItemsAtIndexPaths(indexPaths)
        
    }
        
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
      
      return papersDataSource.numberOfSections
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      //print("\(papersDataSource.count)")
      return papersDataSource.numberOfPapersInSection(section)
    }

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

    let sectionHeaderView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "SectionHeader", forIndexPath: indexPath) as! SectionHeaderView

    if let title = papersDataSource.titleForSectionAtIndexPath(indexPath) {
      sectionHeaderView.title = title
      sectionHeaderView.icon = UIImage(named: title)
    }
    return sectionHeaderView
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      

      let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PaperCell", forIndexPath: indexPath) as! PaperCell
      
      // Configure the cell
      if let paper = papersDataSource.paperForItemAtIndexPath(indexPath) {
        cell.paper = paper
        cell.editing = editing
      }
      
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {

    }
    */

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if !editing {
            if let paper = papersDataSource.paperForItemAtIndexPath(indexPath) {
                performSegueWithIdentifier("MasterToDetail", sender: paper)
            }
        } else {
            navigationController?.setToolbarHidden(false, animated: true)
        }
    }

    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        if editing {
            if collectionView.indexPathsForSelectedItems()?.count == 0 {
                navigationController?.setToolbarHidden(true, animated: true)
            }
        }
    }
    }
