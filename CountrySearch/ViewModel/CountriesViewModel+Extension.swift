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
    private let completion: ((UIImage) -> ())?
    
    init(_ urlStr: String, _ completion: ((UIImage?) -> ())?) {
        self.urlString = urlStr
        self.completion = completion
        super.init()
    }
    
    override func main() {
        if isCancelled { return }
        
        if let imageFromCache = flagImageCache.object(forKey: urlString as NSString) {
            completion?(imageFromCache)
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        asyncLoadData(url).start { (event) in
            switch event {
            case .value(let image):
                flagImageCache.setObject(image, forKey: self.urlString as NSString)
                self.completion?(image)
            case .completed:
                self.state = .Finished
            default: break
            }
        }
    }
    
    private func asyncLoadData(_ url: URL) -> SignalProducer<UIImage, NoError> {
        return SignalProducer { observer, _ in
            if self.isCancelled { return }
            guard let svg = SVGKImage(contentsOf: url), let svgImage = svg.uiImage else { return }
            observer.send(value: svgImage)
            observer.sendCompleted()
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
