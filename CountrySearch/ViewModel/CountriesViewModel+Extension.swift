//
//  CountriesViewModel+Extension.swift
//  CountrySearch
//
//  Created by Vladyslav Kudelia on 10/13/18.
//  Copyright © 2018 Vladyslav Kudelia. All rights reserved.
//

import ReactiveSwift
import Result

let flagImageCache = NSCache<NSString, UIImage>()

class CacheFlagImageOperation: AsyncOperation {
    private let urlString: String
    private let completion: ((UIImage?) -> ())?
    
    init(_ urlStr: String, _ completion: ((UIImage?) -> ())?) {
        self.urlString = urlStr
        self.completion = completion
        super.init()
    }
    
    override func main() {
        if isCancelled { return }
        
        guard let url = URL(string: urlString) else { return }
        asyncLoadData(from: url) { [weak self] (image) in
            guard let `self` = self else { return }
            if self.isCancelled { return }
            flagImageCache.setObject(image, forKey: self.urlString as NSString)
            self.completion?(image)
            self.state = .Finished
        }
    }
    
    private func asyncLoadData(from url: URL, _ completion: @escaping ((UIImage) -> ())) {
        DispatchQueue.global(qos: .background).async {
            usleep(arc4random_uniform(2 * 1000000))
            guard let svg = SVGKImage(contentsOf: url)?.uiImage else { return }
            DispatchQueue.main.async {
                completion(svg)
            }
        }
    }
}

class CacheFlagImageProvider {
    private let operationQueue = OperationQueue()
    let country: CountryEntity
    
    init(_ entity: CountryEntity, _ completion: @escaping (UIImage?) -> ()) {
        country = entity
        let dataLoad = CacheFlagImageOperation(entity.flag, completion)
        operationQueue.addOperation(dataLoad)
    }
    
    func cancel() {
        operationQueue.cancelAllOperations()
    }
}

extension CacheFlagImageProvider: Hashable {
    static func == (lhs: CacheFlagImageProvider, rhs: CacheFlagImageProvider) -> Bool {
        return lhs.country == rhs.country
    }
    
    var hashValue: Int {
        return (country.name + country.flag).hashValue
    }
}
