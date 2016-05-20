//
//  RxFirebaseRemoteConfig.swift
//  Pods
//
//  Created by David Wong on 20/05/2016.
//
//

import FirebaseRemoteConfig
import RxSwift

extension FIRRemoteConfig {
    func rx_fetchWithExpirationDuration(expirationDuration: NSTimeInterval) -> Observable<FIRRemoteConfig> {
        return Observable.create { observer in
            self.fetchWithExpirationDuration(expirationDuration) { (status, error) -> Void in
                if (status == FIRRemoteConfigFetchStatus.Success) {
                    self.activateFetched()
                    observer.onNext(self)
                    observer.onCompleted()
                } else if let error = error{
                    observer.onError(error)
                }
            }
            
            return NopDisposable.instance
        }
    }
}