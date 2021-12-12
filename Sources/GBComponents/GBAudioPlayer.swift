//
//  AudioPlayer.swift
//
//
//  Created by Guillaume Bourachot on 29/10/2019.
//

import Foundation
import AVFoundation

public protocol GBAudioPlayerDelegate: AnyObject {
    func didStart()
    func didPause()
    func didFinish()
    func didUpdateCurrentTime()
    func failedToLoadFrom(url: URL)
    func failedToLoadFrom(data: Data)
}

public class GBAudioPlayer: NSObject, AVAudioPlayerDelegate {
    
    // MARK: - Variable
   public  weak var delegate: GBAudioPlayerDelegate?
    public var isPlaying: Bool {
        return self.audioPlayer?.isPlaying ?? false
    }
    public var progress: Float {
        guard let player = self.audioPlayer else {
            fatalError("No audio player set")
        }
        let progressFloat = Float(player.currentTime / player.duration)
        return progressFloat
    }
    public var totalDuration: TimeInterval {
        guard let player = self.audioPlayer else {
            fatalError("No audio player set")
        }
        return player.duration
    }
    public var hasAlreadyBeenPlayed: Bool = false
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer? = nil {
        willSet {
            timer?.invalidate()
        }
    }
    
    // MARK: - Life cycle
    public func load(localAudioURL: URL, autoStart: Bool = false) {
        do {
            self.hasAlreadyBeenPlayed = false
            audioPlayer = try AVAudioPlayer(contentsOf: localAudioURL)
            self.audioPlayer?.delegate = self
            startObservation()
            if autoStart {
                audioPlayer?.play()
                delegate?.didStart()
            }
        } catch {
            delegate?.failedToLoadFrom(url: localAudioURL)
        }
    }
    
    public func load(distantAudioURL: URL, autoStart: Bool = false) {
        do {
            self.hasAlreadyBeenPlayed = false
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSession.Category.playback)
            let soundData = try Data(contentsOf: distantAudioURL)
            audioPlayer = try AVAudioPlayer(data: soundData)
            audioPlayer?.volume = 1
            audioPlayer?.delegate = self
            startObservation()
            if autoStart {
                audioPlayer?.play()
                delegate?.didStart()
            }
        } catch {
            delegate?.failedToLoadFrom(url: distantAudioURL)
        }
    }
    
    public func load(data: Data, autoStart: Bool = false) {
        do {
            self.hasAlreadyBeenPlayed = false
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSession.Category.playback)
            audioPlayer = try AVAudioPlayer(data: data)
            audioPlayer?.volume = 1
            audioPlayer?.delegate = self
            startObservation()
            if autoStart {
                audioPlayer?.play()
                delegate?.didStart()
            }
        } catch {
            delegate?.failedToLoadFrom(data: data)
        }
    }
    
    public func setVolumeTo(_ volume: Float) {
        if volume > 1 {
            audioPlayer?.volume = 1
        } else if volume < 0 {
            audioPlayer?.volume = 0
        } else {
            audioPlayer?.volume = volume
        }
    }
    
    func preparePlayer() {
            
        }
    
    deinit {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    // MARK: - Getters
    public func currentTime() -> TimeInterval {
        guard let player = self.audioPlayer else {
            fatalError("No audio player set")
        }
        return player.currentTime
    }
    
    public func remainingTime() -> TimeInterval {
        guard let player = self.audioPlayer else {
            fatalError("No audio player set")
        }
        return player.duration - player.currentTime
    }
    
    // MARK: - Functions
    public func togglePlayPause() {
        if audioPlayer?.isPlaying ?? false {
            audioPlayer?.pause()
            delegate?.didPause()
        } else if (audioPlayer?.isPlaying ?? true) == false {
            audioPlayer?.play()
            delegate?.didStart()
        }
    }
    
    public func resume() {
        if (audioPlayer?.isPlaying ?? true) == false,
           !self.hasAlreadyBeenPlayed {
            audioPlayer?.play()
            delegate?.didStart()
        }
    }
    
    public func pause() {
        if audioPlayer?.isPlaying ?? false {
            audioPlayer?.pause()
            delegate?.didPause()
        }
    }
    
    public func fullStop() {
        self.timer?.invalidate()
        self.timer = nil
        self.audioPlayer?.stop()
        self.audioPlayer = nil
    }
    
    public func setCurrentTime(to timeInterval: TimeInterval) {
        guard let player = self.audioPlayer else {
            fatalError("No audio player set")
        }
        var shouldRelaunch: Bool = false
        if player.isPlaying {
            player.pause()
            shouldRelaunch = true
        }
        player.currentTime = timeInterval
        if shouldRelaunch {
            player.play()
        }
        self.delegate?.didUpdateCurrentTime()
    }
    
    public func changeAudio(for audioURL: URL, autoStart: Bool = false){
        self.fullStop()
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            self.audioPlayer?.delegate = self
            startObservation()
            if autoStart {
                audioPlayer?.play()
                delegate?.didStart()
            }
        } catch {
            print("Couldn't load the file")
        }
    }
    
    // MARK: - Timer functions
    private func startObservation() {
        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: (#selector(timerClicked)), userInfo: nil, repeats: true)
    }
    
    @objc private func timerClicked() {
        guard let player = self.audioPlayer else {
            fatalError("No audio player set")
        }
        if player.isPlaying {
            self.delegate?.didUpdateCurrentTime()
        }
    }
    
    // MARK: - AVAudioPlayerDelegate
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.hasAlreadyBeenPlayed = true
        self.delegate?.didFinish()
    }
    
}
