import UIKit
import KTCenterFlowLayout

private let reuseIdentifier = String(SnapTagCell)

public class SnapTagsCollectionViewController: UIViewController {
    
    public var data = [SnapTagRepresentation]()
    public var configuration : SnapTagsViewConfiguration!
    public var buttonConfiguration : SnapTagButtonConfiguration!
    public var delegate : SnapTagsButtonDelegate?
    
    internal var collectionView : UICollectionView!

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        assert(configuration != nil)
        assert(buttonConfiguration != nil)
        
        setupLayout()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupConstraints()
        self.view.backgroundColor = UIColor.clearColor()

        // Register cell classes
        self.collectionView.registerNib(UINib(nibName: "SnapTagCell", bundle: NSBundle(forClass: SnapTagCell.self)), forCellWithReuseIdentifier: reuseIdentifier)

    }
    
    internal func setupLayout() {
        var layout : UICollectionViewFlowLayout
        if configuration.alignment == .Center {
            layout = KTCenterFlowLayout()
        } else {
            layout = UICollectionViewFlowLayout()
        }
        
        layout.minimumLineSpacing = configuration.spacing
        layout.minimumInteritemSpacing = configuration.spacing
        layout.estimatedItemSize = buttonConfiguration.intrinsicContentSize
//        layout.scrollDirection = configuration.scrollDirection
//        layout.headerReferenceSize = CGSizeZero
//        layout.footerReferenceSize = CGSizeZero
//        layout.sectionInset = UIEdgeInsetsZero
//        layout.itemSize = buttonConfiguration.intrinsicContentSize
        
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(collectionView)
    }
    
    internal func setupConstraints() {
        self.view.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let metrics = [
            "hMargin": configuration.horizontalMargin,
            "vMargin": configuration.verticalMargin,
            "height": configuration.contentHeight]
        let views = [ "cv": collectionView ]
        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(hMargin)-[cv]-(hMargin)-|",
            options: [],
            metrics: metrics,
            views: views)
        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(vMargin)-[cv(>=height)]-(vMargin)-|",
            options: [],
            metrics: metrics,
            views: views)
        self.view.addConstraints(hConstraints)
        self.view.addConstraints(vConstraints)
    }
}

extension SnapTagsCollectionViewController : UICollectionViewDataSource {

    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        print("Item #\(indexPath.row)")
        let tag = data[indexPath.item]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SnapTagCell
        let config = buttonConfiguration.duplicate()
        
        config.isOn = tag.isOn
//        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.setText(tag.tag)
        cell.applyConfiguration(buttonConfiguration)
        
        print("Item done #\(indexPath.row)")
        return cell
    }
}

extension SnapTagsCollectionViewController : UICollectionViewDelegateFlowLayout {
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        print("Size #\(indexPath.row)")
        let tag = data[indexPath.item]

        let height = buttonConfiguration.verticalMargin * 2 + buttonConfiguration.font.pointSize
        
        let label = UILabel(frame: CGRectZero)
        label.text = tag.tag
        label.font = buttonConfiguration.font
        
        let labelSize = label.sizeThatFits(CGSizeMake(1000,40))
        var width = buttonConfiguration.horizontalMargin * 2 + labelSize.width
        if buttonConfiguration.isTurnOnOffAble {
            width += buttonConfiguration.spacingBetweenLabelAndOnOffButton + (buttonConfiguration.onOffButtonImage.onImage.size.width)
        }
        return CGSizeMake(width, height)
    }
}

extension SnapTagsCollectionViewController : UICollectionViewDelegate {

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

}