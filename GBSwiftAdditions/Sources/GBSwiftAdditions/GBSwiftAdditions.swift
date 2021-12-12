import Foundation

public func localizedString(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")
}

public func cached<A: Hashable, B>(_ f: @escaping (A) -> B) -> (A) -> B {
    var cache = [A: B]()
    return { (input: A) -> B in
        if let cachedValue = cache[input] {
            return cachedValue
        } else {
            let result = f(input)
            cache[input] = result
            return result
        } }
}

public func debounced<T>(delay: TimeInterval = 0.3,
                  queue: DispatchQueue = .main,
                  action: @escaping ((T) -> Void))
    -> (T) -> Void {
        var workItem: DispatchWorkItem?
        return { arg in
            workItem?.cancel()
            workItem = DispatchWorkItem(block: { action(arg) })
            queue.asyncAfter(deadline: .now() + delay, execute: workItem!)
        }
}

public func preventMultipleCalls<T>(duration: TimeInterval = 0.5,
                             queue: DispatchQueue = .main,
                             action: @escaping ((T) -> Void))
    -> (T) -> Void {
        var workItem: DispatchWorkItem?
        var nextWorkingWindow: DispatchTime?
        return { arg in
            if (nextWorkingWindow ?? .now()) <= .now() {
                nextWorkingWindow = .now() + duration
                workItem = DispatchWorkItem(block: { action(arg) })
                queue.asyncAfter(deadline: .now() , execute: workItem!)
            }
        }
}

public func delay(delay: Double, closure:@escaping ()->()) -> DispatchWorkItem {
    let workItem = DispatchWorkItem { closure() }
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: workItem)
    return workItem
}
