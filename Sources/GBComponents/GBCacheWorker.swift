//
//  GBCacheWorker.swift
//  
//
//  Created by Guillaume Bourachot on 12/12/2021.
//

import Foundation

public protocol GBCacheLogic: AnyObject {
    func saveCache(object: Any, for key: NSString)
    func getCachedObject(for key: NSString) -> Any?
    func removeCache(for key: NSString)
}

public class GBCacheWorker: GBCacheLogic {
    private class Box {
        let value : Any
        init(_ value : Any) { self.value = value }
    }
    
    static public let shared : GBCacheLogic = GBCacheWorker()
    
    private let internalCache = NSCache<NSString, Box>()
    
    public func saveCache(object: Any, for key: NSString) {
        self.internalCache.setObject(.init(object), forKey: key)
    }
    
    public func getCachedObject(for key: NSString) -> Any? {
        return self.internalCache.object(forKey: key)?.value
    }
    
    public func removeCache(for key: NSString) {
        self.internalCache.removeObject(forKey: key as NSString)
    }
}
