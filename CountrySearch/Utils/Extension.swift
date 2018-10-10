//
//  Extension.swift
//  CountrySearch
//
//  Created by Vladyslav Kudelia on 10/10/18.
//  Copyright © 2018 Vladyslav Kudelia. All rights reserved.
//

import UIKit

// MARK: ReuseIdentifier
protocol ReusableView: class {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return NSStringFromClass(self)
    }
}

// MARK: NibLoadableView
protocol NibLoadableView: class {
    static var nibName: String { get }
}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

protocol UIViewNibLoadable {}
extension UIView: UIViewNibLoadable {}
extension UIViewNibLoadable where Self: UIView {
    static func instanciateFromNib() -> Self {
        let nibName = "\(self)".split{$0 == "."}.map(String.init).last!
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! Self
    }
}

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}

extension UITableView {
    
    func register<C: UITableViewCell>(_: C.Type) where C: ReusableView {
        register(C.self, forCellReuseIdentifier: C.defaultReuseIdentifier)
    }
    
    func register<C: UITableViewCell>(_: C.Type) where C: ReusableView, C: NibLoadableView {
        let bundle = Bundle(for: C.self)
        let nib = UINib(nibName: C.nibName, bundle: bundle)
        register(nib, forCellReuseIdentifier: C.defaultReuseIdentifier)
    }
    
    func dequeueReusableCell<C: UITableViewCell> (forIndexPath indexPath: IndexPath) -> C where C: ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: C.defaultReuseIdentifier, for: indexPath as IndexPath) as? C else {
            fatalError("Could not dequeue cell with identifier: \(C.defaultReuseIdentifier)")
        }
        return cell
    }
}
