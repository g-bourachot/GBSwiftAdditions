//
//  GBTimerWorker.swift
//
//
//  Created by Guillaume Bourachot on 29/10/2019.
//

import Foundation

public protocol GBTimerWorkerDelegate: AnyObject {
    func updateElapsedTime(with timeInterval: TimeInterval)
    func timerDidFinish()
}

public class GBTimerWorker {
    
    public enum Mode {
        case countDown
        case countUp
    }
    
    // MARK: - Variables
    public weak var delegate: GBTimerWorkerDelegate?
    public var mode: Mode = .countDown
    private var timer: Timer? = nil {
        willSet {
            timer?.invalidate()
        }
    }
    private var startDate: Date = Date()
    private var isStarted: Bool = false
    private var extraElapsedTime: TimeInterval = 0
    private var timeInterval: TimeInterval = 0
    private var pausedRemainingTime: TimeInterval = 0
    
    // MARK: - life cycle
    public init() {}
    
    deinit {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    // MARK: - Functions
    public func start(with timeInterval: TimeInterval) {
        self.reset()
        self.timeInterval = timeInterval
        self.start()
    }
    
    public func start() {
        if !self.isStarted {
            assert(self.delegate != nil)
            assert((self.timeInterval-self.extraElapsedTime) > 0.0)
            self.startDate = Date()
            self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: (#selector(updateEvent)), userInfo: nil, repeats: true)
            self.isStarted = true
        }
    }
    
    public func pause() {
        if self.isStarted {
            self.timer?.invalidate()
            self.timer = nil
            self.pausedRemainingTime = self.remainingTime()
            self.isStarted = false
        }
    }
    
    public func resume() {
        if !self.isStarted {
            assert(self.delegate != nil)
            assert((self.timeInterval-self.extraElapsedTime) > 0.0)
            self.start(with: self.pausedRemainingTime)
        }
    }
    
    public func stop() {
        if self.isStarted {
            self.timer?.invalidate()
            self.timer = nil
            self.extraElapsedTime = self.elapsedTime()
            self.isStarted = false
        } else {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    public func reset() {
        self.stop()
        self.timeInterval = 0
        self.extraElapsedTime = 0
    }
    
    public func elapsedTime() -> TimeInterval {
        var result: TimeInterval = self.extraElapsedTime
        if self.isStarted {
            result += -self.startDate.timeIntervalSinceNow
        }
        return round(result)
    }
    
    public func remainingTime() -> TimeInterval {
        var result: TimeInterval = self.timeInterval
        if self.isStarted {
            result = self.timeInterval+self.startDate.timeIntervalSinceNow
        }
        return round(result)
    }
    
    // MARK: - Private functions
    @objc private func updateEvent() {
        if let delegate = self.delegate {
            if round(self.timeInterval-self.elapsedTime()) <= 0 {
                self.reset()
                delegate.timerDidFinish()
            } else {
                switch self.mode {
                case .countDown:
                    delegate.updateElapsedTime(with: self.remainingTime())
                case .countUp:
                    delegate.updateElapsedTime(with: self.elapsedTime())
                }
            }
        } else {
            self.stop()
        }
    }
}
