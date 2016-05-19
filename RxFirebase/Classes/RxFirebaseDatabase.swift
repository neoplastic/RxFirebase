//
//  RxFirebaseDatabase.swift
//  Pods
//
//  Created by David Wong on 19/05/2016.
//
//

import FirebaseDatabase
import RxSwift

extension FIRDatabaseQuery {
    func rx_observe(eventType: FIRDataEventType) -> Observable<FIRDataSnapshot> {
        return Observable.create { observer in
            let handle = self.observeEventType(eventType) { (snapshot) in
                observer.onNext(snapshot)
            }
            return AnonymousDisposable {
                self.removeObserverWithHandle(handle)
            }
        }
    }
    
    func rx_observeWithSiblingKey(eventType: FIRDataEventType) -> Observable<(FIRDataSnapshot, String?)> {
        return Observable.create { observer in
            let handle = self.observeEventType(eventType, andPreviousSiblingKeyWithBlock: { (snapshot, siblingKey) in
                observer.onNext((snapshot, siblingKey))
            })
            return AnonymousDisposable {
                self.removeObserverWithHandle(handle)
            }
        }
    }
}

extension FIRDatabaseReference {
    func rx_updateChildValues(values: [String : AnyObject]) -> Observable<FIRDatabaseReference> {
        return Observable.create { observer in
            self.updateChildValues(values, withCompletionBlock: { (error, databaseReference) in
                if let error = error {
                    observer.onError(error)
                    return
                } else {
                    observer.onNext(databaseReference)
                    observer.onCompleted()
                }
            })
            
            return NopDisposable.instance
        }
    }
    
    func rx_setValue(value: AnyObject!, priority: AnyObject? = nil) -> Observable<FIRDatabaseReference> {
        return Observable.create { observer in
            self.setValue(value, andPriority: priority, withCompletionBlock: { (error, databaseReference) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(databaseReference)
                    observer.onCompleted()
                }
            })
            return NopDisposable.instance
        }
    }
    
    func rx_removeValue() -> Observable<FIRDatabaseReference> {
        return Observable.create { observer in
            self.removeValueWithCompletionBlock({ (error, databaseReference) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(databaseReference)
                    observer.onCompleted()
                }
            })
            return NopDisposable.instance
        }
    }
    
    func rx_runTransactionBlock(block: ((FIRMutableData!) -> FIRTransactionResult)!) -> Observable<(isCommitted: Bool, snapshot: FIRDataSnapshot?)> {
        return Observable.create { observer in
            self.runTransactionBlock(block, andCompletionBlock: { (error, isCommitted, snapshot) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext((isCommitted, snapshot))
                    observer.onCompleted()
                }
            })
            return NopDisposable.instance
        }
    }
    
    func rx_setPriority(priority : AnyObject) -> Observable<FIRDatabaseReference> {
        return Observable.create { observer in
            self.setPriority(priority, withCompletionBlock: { (error, databaseReference) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(databaseReference)
                    observer.onCompleted()
                }
            })
            return NopDisposable.instance
        }
    }
    
    func rx_onDisconnectSetValue(value: AnyObject, priority: AnyObject? = nil) -> Observable<FIRDatabaseReference> {
        return Observable.create { observer in
            self.onDisconnectSetValue(value, andPriority: priority, withCompletionBlock: { (error, databaseReference) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(databaseReference)
                    observer.onCompleted()
                }
            })
            return NopDisposable.instance
        }
    }
    
    func rx_onDisconnectUpdateValue(values: [String : AnyObject]) -> Observable<FIRDatabaseReference> {
        return Observable.create { observer in
            self.onDisconnectUpdateChildValues(values, withCompletionBlock: { (error, databaseReference) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(databaseReference)
                    observer.onCompleted()
                }
            })
            return NopDisposable.instance
        }
    }
    
    func rx_onDisconnectRemoveValueWithCompletionBlock() -> Observable<FIRDatabaseReference> {
        return Observable.create { observer in
            self.onDisconnectRemoveValueWithCompletionBlock({ (error, databaseReference) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(databaseReference)
                    observer.onCompleted()
                }
            })
            return NopDisposable.instance
        }
    }
}