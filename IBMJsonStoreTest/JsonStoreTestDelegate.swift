//
//  JsonStoreTestDelegate.swift
//  mobileapp
//
//  Created by Leo on 30/9/20.
//  Copyright © 2020 sppl. All rights reserved.
//

import Foundation
import IBMMobileFirstPlatformFoundationJSONStore
class JsonStoreTestDelegate: PPAppDelegteProtocol {
    var deviceID: String {
        return String((UIDevice.current.identifierForVendor?.uuidString ?? "").prefix(4))
    }

    var usernameStore: String { return deviceID }
    var storePaz: String { return deviceID + deviceID.prefix(2) }
    enum JsonStoreError: Error {
        case instanceNil
        case collectionNil
        case decodeError
    }
    let collectionName: String = "MyStore"
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions
                        launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if findCollection() == false {
            addCollection()
            _ = findCollection()
        }
        else {
            replaceCollection()
            _ = findCollection()
        }
        return true
    }
    func replaceCollection() {
        let data1: [String: Any] = ["name": "aromal", "age": Int.random(in: 1..<100)]
        let document: [String: Any] = ["_id": 1, "json": data1]
        do {
            print("🟥 🟥 replacing existing data with \(data1) ")
            let collection = try openCollection(name: collectionName)
            try collection.replaceDocuments([document], andMarkDirty: false)
            print("🟥 🟥 replace data in json store success")
        } catch let error as NSError {
            print("🟥 🟥 replace error ", error)
        }
    }
    func addCollection() {
        let data1: [String: Any] = ["name": "aromal", "age": 32]
        do {
            print("🟥 🟥 adding data \(data1) ")
            let collection = try openCollection(name: collectionName)
            try collection.addData([data1], andMarkDirty: false, with: nil)
            print("🟥 🟥 added data to json store success")
        } catch let error as NSError {
            print("🟥 🟥 add error ", error)
        }
    }
    func findCollection() -> Bool{
        do {
            let collection = try openCollection(name: collectionName)
            let results = try collection.find(withIds: [1], andOptions: nil)
            print("🟥 🟥 finding data from json store")
            if let data = results.first as? [String: Any],
                let json: [String: Any] = data["json"]  as? [String: Any] {
                let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                let stringJson = String(data: jsonData, encoding: .utf8)
                print("🟥 🟥 Data is ", stringJson ?? "No Json")
            } else {
                throw JsonStoreError.decodeError
            }
        } catch let error as NSError {
            print("🟥 🟥 find error ", error)
            return false
        }
        return true
    }
    func openCollection(name: String) throws -> JSONStoreCollection {
        guard let jsonStoreinstance = JSONStore.sharedInstance() else {
            throw JsonStoreError.instanceNil
        }
        let collection: JSONStoreCollection = JSONStoreCollection(name: name)
        let passwordOptions: JSONStoreOpenOptions? = JSONStoreOpenOptions()
        passwordOptions?.username = usernameStore
        passwordOptions?.password = storePaz
        do {
//            print("🟥 🟥 trying to open collection \(name)")
            try jsonStoreinstance.openCollections([collection], with: passwordOptions)
        } catch {
//            print("🟥 🟥 error in openning", error)
        }
        let openedCollection = jsonStoreinstance.getCollectionWithName(name)
        if openedCollection == nil {
            throw JsonStoreError.collectionNil
        }
        return openedCollection!
    }
}
