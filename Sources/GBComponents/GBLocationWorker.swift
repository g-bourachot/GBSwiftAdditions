//
//  GBLocationWorker.swift
//  
//
//  Created by Guillaume Bourachot on 12/12/2021.
//

import Foundation
import CoreLocation

public protocol GBLocationLogic: AnyObject {
    func setUpLocationManager()
    func requestLocation(_ completion: @escaping (Result<CLLocation, Error>) -> Void)
}

public class GBLocationWorker: NSObject, GBLocationLogic {
    
    //MARK: - Variables
    let locationManager = CLLocationManager()
    var completionHandlers : [(Result<CLLocation, Error>) -> Void] = []
    
    var location : CLLocation?
    
    //MARK: - Internal functions
    override init() {
        super.init()
        self.setUpLocationManager()
    }
    
    public func setUpLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
    }
    
    public func requestLocation(_ completion: @escaping (Result<CLLocation, Error>) -> Void) {
        locationManager.startUpdatingLocation()
        self.completionHandlers.append(completion)
    }
}

extension GBLocationWorker: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.last
        for completionHandler in self.completionHandlers {
                completionHandler(.success(locations.last!))
        }
        self.completionHandlers = []
        self.locationManager.stopUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        for completionHandler in self.completionHandlers {
            completionHandler(.failure(error))
        }
        self.completionHandlers = []
        self.locationManager.stopUpdatingLocation()
    }
}
