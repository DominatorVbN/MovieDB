//
//  Cache.swift
//  MovieDB
//
//  Created by Amit Samant on 30/10/21.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    fileprivate let wrapped = NSCache<WrappedKey, Entry>()
    fileprivate let dateProvider: () -> Date
    fileprivate let entryLifetime: TimeInterval
    fileprivate let keyTracker = KeyTracker()
    
    var isEmpty: Bool {
        guard !keyTracker.keys.isEmpty else {
            return true
        }
        return keyTracker.keys.allSatisfy {
            value(forKey: $0) == nil
        }
    }
    
    init(
        dateProvider: @escaping () -> Date = Date.init,
        entryLifetime: TimeInterval = 12 * 60 * 60,
        maximumEntryCount: Int = 100
    ) {
        self.dateProvider = dateProvider
        self.entryLifetime = entryLifetime
        wrapped.countLimit = maximumEntryCount
        wrapped.delegate = keyTracker
    }
    
    func insert(_ value: Value, forKey key: Key) {
        let date = dateProvider().addingTimeInterval(entryLifetime)
        let entry = Entry(key: key, value: value, expirationDate: date)
        wrapped.setObject(entry, forKey: WrappedKey(key))
        keyTracker.keys.insert(key)
    }
    
    func value(forKey key: Key) -> Value? {
        guard let entry = wrapped.object(forKey: WrappedKey(key)) else {
            return nil
        }
        guard dateProvider() < entry.expirationDate else {
            // Discard values that have expired
            removeValue(forKey: key)
            return nil
        }
        return entry.value
    }
    
    func removeValue(forKey key: Key) {
        wrapped.removeObject(forKey: WrappedKey(key))
    }
    
    subscript(key: Key) -> Value? {
        get { return value(forKey: key) }
        set {
            guard let value = newValue else {
                // If nil was assigned using our subscript,
                // then we remove any value for that key:
                removeValue(forKey: key)
                return
            }
            insert(value, forKey: key)
        }
    }
}

private extension Cache {
    
    final class Entry {
        let key: Key
        let value: Value
        let expirationDate: Date

        init(key: Key, value: Value, expirationDate: Date) {
            self.key = key
            self.value = value
            self.expirationDate = expirationDate
        }
    }
    
    final class WrappedKey: NSObject {
        let key: Key
        override var hash: Int { return key.hashValue }

        init(_ key: Key) {
            self.key = key
        }

        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else {
                return false
            }
            return value.key == key
        }
    }
    
    final class KeyTracker: NSObject, NSCacheDelegate {
        var keys = Set<Key>()

        func cache(
            _ cache: NSCache<AnyObject, AnyObject>,
            willEvictObject object: Any
        ) {
            guard let entry = object as? Entry else {
                return
            }
            debugPrint("Evicting object for key: \(entry.key)")
            keys.remove(entry.key)
        }
    }
}
