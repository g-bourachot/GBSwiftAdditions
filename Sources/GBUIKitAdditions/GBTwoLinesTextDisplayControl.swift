//
//  GBTwoLinesTextDisplayControl.swift
//  
//
//  Created by Guillaume Bourachot on 12/12/2021.
//

import Foundation
#if canImport(UIKit)
import UIKit

public class GBTwoLinesTextDisplayControl : UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Variables
    public var controls : [UIView] = [] {
        didSet {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    public var contentHeight : CGFloat = 50.0
    private var collectionView : UICollectionView!
    private var dataSource : GBTwoLinesTextDataSource = GBTwoLinesTextDataSource()
    
    public var intrinsicContentHeight: CGFloat {
        return self.collectionView.collectionViewLayout.collectionViewContentSize.height
    }
    
    private var collectionViewHeightConstraint: NSLayoutConstraint!
    
    //MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUp()
    }
    
    //MARK: - Functions
    public func setUp() {
        self.dataSource.content.removeAll()
        for control in self.controls {
            self.dataSource.content.append(control)
        }
    }
    
    public func setUpTwoLinesControl(with entries: [(firstLine: String, secondLine: String)] = [], color: UIColor? = .black) {
        var textViewArray: [GBTwoLinesTextView] = []
        for entry in entries {
            let twoLinesTextView = GBTwoLinesTextView.init()
            twoLinesTextView.title = entry.firstLine + "\n" + entry.secondLine
            twoLinesTextView.color = color
            textViewArray.append(twoLinesTextView)
        }
        self.controls = textViewArray
        self.setUp()
        self.configureCollectionView()
    }
    
    public func addView(_ view: UIView, at index: Int) {
        self.controls.insert(view, at: index)
        self.setUp()
    }
    
    public func replaceView(with view: UIView, at index: Int) {
        self.controls.remove(at: index)
        self.controls.insert(view, at: index)
        self.setUp()
    }
    
    public func frameForCell(at indexPath: IndexPath) -> CGRect {
        if self.collectionView != nil {
            guard let attributes = collectionView.layoutAttributesForItem(at: indexPath) else {
                return CGRect.zero
            }
            return attributes.frame
        }
        return CGRect.zero
    }
    
    private func configureCollectionView() {
        DispatchQueue.main.async {
            self.backgroundColor = UIColor.clear
            let layout: UICollectionViewFlowLayout = LeftAlignedCollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.sectionInset = UIEdgeInsets.zero
            
            if !(self.collectionView != nil) {
                self.collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
                self.collectionView.dataSource = self
                self.collectionView.isScrollEnabled = false
                self.collectionView.delegate = self
                self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
                self.collectionView.backgroundColor = UIColor.clear
                self.addSubview(self.collectionView)
                self.collectionView.translatesAutoresizingMaskIntoConstraints = false
            }
            
            self.collectionViewHeightConstraint = self.collectionView.heightAnchor.constraint(equalToConstant: 50)
            self.collectionViewHeightConstraint.priority = UILayoutPriority.init(rawValue: 998)
            self.collectionViewHeightConstraint.isActive = true
            self.topAnchor.constraint(equalTo: self.collectionView.topAnchor).isActive = true
            self.bottomAnchor.constraint(equalTo: self.collectionView.bottomAnchor).isActive = true
            self.leftAnchor.constraint(equalTo: self.collectionView.leftAnchor).isActive = true
            self.rightAnchor.constraint(equalTo: self.collectionView.rightAnchor).isActive = true
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.refreshUI()
        }
    }
    
    public func refreshUI() {
        self.collectionView.reloadData()
        if self.collectionView.collectionViewLayout.collectionViewContentSize.height > 0 {
            self.collectionViewHeightConstraint = self.collectionView.heightAnchor.constraint(equalToConstant: self.collectionView.collectionViewLayout.collectionViewContentSize.height)
            self.collectionViewHeightConstraint.isActive = true
            self.contentHeight = self.collectionViewHeightConstraint.constant
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    //MARK: - UICollectionViewDataSource
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let element = self.dataSource.itemAtIndex(index: indexPath.row)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.subviews.forEach({ $0.removeFromSuperview() })
        cell.backgroundColor = UIColor.clear
        cell.addSubview(element)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.numberOfItems
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.dataSource.sizeForItem(at: indexPath.row) == .zero {
            return CGSize.init(width: 1, height: 1)
        }
        return self.dataSource.sizeForItem(at: indexPath.row)
    }
}

public struct GBTwoLinesTextDataSource {
    //MARK: - Variables
    public var content: [UIView] = []
    public var numberOfItems: Int {
        return self.content.count
    }
    
    public func itemAtIndex(index : Int) -> UIView {
        return self.content[index]
    }
    
    public func sizeForItem(at index: Int) -> CGSize {
        return self.content[index].frame.size
    }
}

public class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        
        return attributes
    }
}

public class GBTwoLinesTextView: UIView {
    //MARK: - Variables
    public var titleLabel : UILabel = UILabel(frame: CGRect.zero)
    public var title : String? {
        didSet {
            if self.titleLabel.text != self.title {
                self.titleLabel.text = self.title
                self.updateFrameSize()
                self.invalidateIntrinsicContentSize()
            }
        }
    }
    public var color : UIColor? {
        didSet {
            if self.titleLabel.textColor != self.color {
                self.titleLabel.textColor = self.color
                self.updateFrameSize()
                self.invalidateIntrinsicContentSize()
            }
        }
    }
    public let contentStackView = UIStackView()
    
    //MARK: - Life cycle
    override init(frame: CGRect) {
        self.titleLabel = UILabel(frame: CGRect.zero)
        super.init(frame: frame)
        self.afterInitSetup()
    }
    required init?(coder aDecoder: NSCoder) {
        self.titleLabel = UILabel(frame: CGRect.zero)
        super.init(coder: aDecoder)
        self.afterInitSetup()
    }
    
    //MARK: - Functions
    private func afterInitSetup() {
        
        //configuration
        self.contentMode = .redraw
        self.contentStackView.isUserInteractionEnabled = false
        
        //Text Label
        _ = self.titleLabel.centerYAnchor.constraint(equalTo: self.contentStackView.centerYAnchor)
        _ = self.titleLabel.centerXAnchor.constraint(equalTo: self.contentStackView.centerXAnchor)
        self.titleLabel.textAlignment = .left
        self.titleLabel.numberOfLines = 0
        
        //Stack view
        self.contentStackView.axis = .horizontal
        self.contentStackView.alignment = .center
        self.contentStackView.distribution = .equalSpacing
        self.contentStackView.spacing = 4
        self.contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        //Addition of the views
        self.contentStackView.addArrangedSubview(self.titleLabel)
        self.addSubview(self.contentStackView)
        
        //Constraints
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentStackView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["contentStackView" : self.contentStackView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[contentStackView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["contentStackView" : self.contentStackView]))
        self.addConstraint(NSLayoutConstraint(item: self.contentStackView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
    }
    
    public func updateFrameSize() {
        self.titleLabel.sizeToFit()
        self.frame.size = CGSize.init(width: self.titleLabel.frame.size.width, height: self.titleLabel.frame.size.height)
    }
}
#endif

