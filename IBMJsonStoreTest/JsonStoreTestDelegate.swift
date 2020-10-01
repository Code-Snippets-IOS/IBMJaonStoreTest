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
        addCollection()
        findCollection()
        replaceCollection()
        findCollection()
        return true
    }
    func replaceCollection() {
        let data1: [String: Any] = ["name": "aromal replaceed", "age": 12]
        let document: [String: Any] = ["_id": 1, "json": data1]
        do {
            let collection = try openCollection(name: collectionName)
            try collection.replaceDocuments([document], andMarkDirty: false)
            print("🟥 🟥 replaceCollection data to json store success")
        } catch let error as NSError {
            print("🟥 🟥 replaceCollection error ", error)
        }
    }
    func addCollection() {
        let data1: [String: Any] = ["name": "aromal", "age": 32]
        do {
            let collection = try openCollection(name: collectionName)
            try collection.addData([data1], andMarkDirty: false, with: nil)
            print("🟥 🟥 added data to json store success")
        } catch let error as NSError {
            print("🟥 🟥 addCollection error ", error)
        }
    }
    func findCollection() {
        do {
            let collection = try openCollection(name: collectionName)
            let results = try collection.find(withIds: [1], andOptions: nil)
            print("🟥 🟥 find data from json store success")
            if let data = results.first as? [String: Any],
                let json: [String: Any] = data["json"]  as? [String: Any] {
                let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                let stringJson = String(data: jsonData, encoding: .utf8)
                print("🟥 🟥 Data is ", stringJson ?? "No Json")
            } else {
                throw JsonStoreError.decodeError
            }
        } catch let error as NSError {
            print("🟥 🟥 findCollection error ", error)
        }
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
            print("🟥 🟥 trying to open collection \(name)")
            try jsonStoreinstance.openCollections([collection], with: passwordOptions)
        } catch let error {
            print("🟥 🟥 error in openning", error)
        }
        let openedCollection = jsonStoreinstance.getCollectionWithName(name)
        if openedCollection == nil {
            throw JsonStoreError.collectionNil
        }
        return openedCollection!
    }
}
