//
//  RxFirebaseAuth.swift
//  RxFirebase
//
//  Created by David Wong on 05/19/2016.
//  Copyright (c) 2016 David Wong. All rights reserved.
//

import FirebaseAnalytics
import FirebaseAuth
import RxSwift

public extension FIRAuth {
    var rx_addAuthStateDidChangeListener: Observable<(FIRAuth, FIRUser?)> {
        get {
            return Observable.create { observer in
                let listener = self.addAuthStateDidChangeListener({ (auth, user) in
                    observer.onNext((auth, user))
                    observer.onCompleted()
                })
                return AnonymousDisposable {
                    self.removeAuthStateDidChangeListener(listener)
                }
            }
        }
    }
    
    func rx_signinWithEmail(email: String, password: String) -> Observable<FIRUser?> {
        return Observable.create { observer in
            
            self.signInWithEmail(email, password: password, completion: { (user, error) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(user)
                    observer.onCompleted()
                }
            })
            
            return NopDisposable.instance
        }
    }
    
    func rx_signInAnonymously() -> Observable<FIRUser?> {
        return Observable.create { observer in
            self.signInAnonymouslyWithCompletion({ (user, error) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(user)
                    observer.onCompleted()
                }
            })
            
            return NopDisposable.instance
        }
    }
    
    func rx_signInWithCredentials(credentials: FIRAuthCredential) -> Observable<FIRUser?> {
        return Observable.create { observer in
            FIRAuth.auth()?.signInWithCredential(credentials, completion: { (user, error) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(user)
                    observer.onCompleted()
                }
            })
            
            return NopDisposable.instance
        }
    }
    
    func rx_signInWithCustomToken(token: String) -> Observable<FIRUser?> {
        return Observable.create { observer in
            self.signInWithCustomToken(token, completion: { (user, error) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(user)
                    observer.onCompleted()
                }
            })
            
            return NopDisposable.instance
        }
    }
    
    func rx_createUserWithEmail(email: String, password: String) -> Observable<FIRUser?> {
        return Observable.create { observer in
            self.createUserWithEmail(email, password: password, completion: { (user, error) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(user)
                    observer.onCompleted()
                }
            })
            
            return NopDisposable.instance
        }
    }
    
}
