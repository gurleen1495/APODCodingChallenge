//
//  DBManager.swift
//  CodingChallengeAPOD
//
//  Created by Gurleen kaur on 9/4/22.
//

import Foundation
import RealmSwift

class RealmManager {
    
    var realm = try? Realm()
    
    func deleteDatabase() {
        try! realm?.write({
            realm?.deleteAll()
        })
    }
    
    func deleteObject(objs : Object) {
        try? realm!.write ({
            realm?.delete(objs)
        })
    }
    
    func deleteAllObject() {
        try? realm!.write ({
            realm?.deleteAll()
        })
    }
    
    func saveObjects(objs: Object) {
        try? realm!.write ({
            realm?.add(objs)
        })
    }
    
    func getObjects(type: Object.Type) -> Results<Object>? {
        if realm == nil{
            realm = try? Realm()
            return realm!.objects(type)
        }
        return realm!.objects(type)
    }
    
    func objectExists(id: String) -> Bool {
        return realm!.object(ofType: AstroPictureOfTheDay.self, forPrimaryKey: id) != nil
    }
    
    func getObject(id: String) ->  AstroPictureOfTheDay? {
        return realm!.object(ofType: AstroPictureOfTheDay.self, forPrimaryKey: id)
    }
}
