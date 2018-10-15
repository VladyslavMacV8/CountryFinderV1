//
//  GeneralViewModel.swift
//  CountrySearch
//
//  Created by Vladyslav Kudelia on 10/10/18.
//  Copyright © 2018 Vladyslav Kudelia. All rights reserved.
//

import RealmSwift

protocol GeneralViewModelProtocol: class {
    var presenter: Presenter { get }
    
    func configureSignals()
}

class GeneralViewModel: GeneralViewModelProtocol {
    
    lazy var presenter: Presenter = PresenterImpl()
    
    init() {
        configureSignals()
    }
    
    func configureSignals() {}
}

protocol RealmProtocol: class {
    func saveObject(_ value: Object)
    func getDataFromArray(_ value: Object.Type) -> Results<Object>?
    func deleteObject(_ value: Object.Type, _ key: String)
    func deleteAllDB()
    func isObjectExist(_ key: String, _ value: Object.Type) -> Bool
}

extension GeneralViewModel: RealmProtocol {
    
    func saveObject(_ value: Object) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(value, update: true)
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
    func getDataFromArray(_ value: Object.Type) -> Results<Object>? {
        
        var result: Results<Object>?
        
        do {
            let realm = try Realm()
            result = realm.objects(value)
            
        } catch let error {
            debugPrint(error.localizedDescription)
        }
        
        return result
    }
    
    func deleteObject(_ value: Object.Type, _ key: String) {
        do {
            let realm = try Realm()
            try realm.write {
                guard let object = realm.object(ofType: value, forPrimaryKey: key) else { return }
                realm.delete(object)
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
    func deleteAllDB() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        } catch let error {
            debugPrint("can't get data from DB \(error)")
        }
    }
    
    func isObjectExist(_ key: String, _ value: Object.Type) -> Bool {
        do {
            let realm = try Realm()
            return realm.object(ofType: value, forPrimaryKey: key) != nil
        } catch { return false }
    }
}
