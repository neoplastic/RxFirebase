//
//  RxFirebaseStorage.swift
//  Pods
//
//  Created by David Wong on 19/05/2016.
//
//

import FirebaseStorage
import RxSwift

extension FIRStorageReference {
    // MARK: UPLOAD
    func rx_putData(data: NSData, metaData: FIRStorageMetadata? = nil) -> Observable<FIRStorageUploadTask> {
        return Observable.create { observer in
            observer.onNext(self.putData(data, metadata: metaData, completion: { (metadata, error) in }))
            return NopDisposable.instance
        }
    }
    
    func rx_putDataWithProgress(data: NSData, metaData: FIRStorageMetadata? = nil) -> Observable<(FIRStorageTaskSnapshot, FIRStorageTaskStatus)> {
        return rx_putData(data, metaData: metaData).rx_storageStatus()
    }
    
    func rx_putFile(path: NSURL, metadata: FIRStorageMetadata? = nil) -> Observable<FIRStorageUploadTask> {
        return Observable.create { observer in
            let uploadTask = self.putFile(path, metadata: metadata, completion: { (metadata, error) in })
            observer.onNext(uploadTask)
            return AnonymousDisposable {
                uploadTask.cancel()
            }
        }
    }
    
    func rx_putFileWithProgress(path: NSURL, metaData: FIRStorageMetadata? = nil) -> Observable<(FIRStorageTaskSnapshot, FIRStorageTaskStatus)> {
        return rx_putFile(path).rx_storageStatus()
    }
    
    func rx_dataWithMaxSize(size: Int64) -> Observable<NSData?> {
        return Observable.create { observer in
            let download = self.dataWithMaxSize(size, completion: { (data, error) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(data)
                    observer.onCompleted()
                }
            })
            return AnonymousDisposable {
                download.cancel()
            }
        }
    }
    
    func rx_dataWithMaxSizeProgress(size: Int64) -> Observable<(NSData?, FIRStorageTaskSnapshot?, FIRStorageTaskStatus?)> {
        return Observable.create { observer in
            let download = self.dataWithMaxSize(size, completion: { (data, error) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext((data, nil, .Success))
                    observer.onCompleted()
                }
            })
            
            download.observeStatus(.Progress, handler: { (snapshot: FIRStorageTaskSnapshot) in
                if let error = snapshot.error {
                    observer.onError(error)
                } else {
                    observer.onNext((nil, snapshot, .Progress))
                }
            })
            
            return AnonymousDisposable {
                download.cancel()
            }
        }
    }
    
    // MARK: DOWNLOAD
    func rx_writeToFile(localURL: NSURL) -> Observable<NSURL?> {
        return Observable.create { observer in
            let download = self.writeToFile(localURL, completion: { (url, error) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(url)
                    observer.onCompleted()
                }
            })
            return AnonymousDisposable {
                download.cancel()
            }
        }
    }
    
    func rx_writeToFileWithProgress(localURL: NSURL) -> Observable<(NSURL?, FIRStorageTaskSnapshot?, FIRStorageTaskStatus?)> {
        return Observable.create { observer in
            let download = self.writeToFile(localURL, completion: { (url, error) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext((url, nil, .Success))
                    observer.onCompleted()
                }
            })
            
            download.observeStatus(.Progress, handler: { (snapshot: FIRStorageTaskSnapshot) in
                if let error = snapshot.error {
                    observer.onError(error)
                } else {
                    observer.onNext((nil, snapshot, .Progress))
                }
            })
            
            return AnonymousDisposable {
                download.cancel()
            }
        }
    }
    
    func rx_downloadURL() -> Observable<NSURL?> {
        return Observable.create { observable in
            self.downloadURLWithCompletion({ (url, error) in
                if let error = error {
                    observable.onError(error)
                } else {
                    observable.onNext(url)
                    observable.onCompleted()
                }
            })
            return NopDisposable.instance
        }
    }
    
    // MARK: DELETE
    func rx_delete() -> Observable<Void> {
        return Observable.create { observable in
            self.deleteWithCompletion({ error in
                if let error = error {
                    observable.onError(error)
                } else {
                    observable.onNext()
                    observable.onCompleted()
                }
            })
            return NopDisposable.instance
        }
    }
    
    // MARK: METADATA
    func rx_metadata() -> Observable<FIRStorageMetadata?> {
        return Observable.create { observer in
            self.metadataWithCompletion({ (metadata, error) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(metadata)
                    observer.onCompleted()
                }
            })
            return NopDisposable.instance
        }
    }
    
    func rx_updateMetadata(metadata: FIRStorageMetadata) -> Observable<FIRStorageMetadata?> {
        return Observable.create { observer in
            self.updateMetadata(metadata, completion: { (metadata, error) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(metadata)
                    observer.onCompleted()
                }
            })
            return NopDisposable.instance
        }
    }
    
}

extension FIRStorageUploadTask {
    func rx_observeStatus(status: FIRStorageTaskStatus) -> Observable<(FIRStorageTaskSnapshot, FIRStorageTaskStatus)> {
        return Observable.create { observer in
            let observeStatus = self.observeStatus(status, handler: { (snapshot: FIRStorageTaskSnapshot) in
                if let error = snapshot.error {
                    observer.onError(error)
                } else {
                    observer.onNext((snapshot, status))
                    if status == .Success {
                        observer.onCompleted()
                    }
                }
            })
            return AnonymousDisposable {
                self.removeObserverWithHandle(observeStatus)
            }
        }
    }
}

extension FIRStorageDownloadTask {
    func rx_observeStatus(status: FIRStorageTaskStatus) -> Observable<(FIRStorageTaskSnapshot, FIRStorageTaskStatus)> {
        return Observable.create { observer in
            let observeStatus = self.observeStatus(status, handler: { snapshot in
                if let error = snapshot.error {
                    observer.onError(error)
                } else {
                    observer.onNext((snapshot, status))
                    if status == .Success {
                        observer.onCompleted()
                    }
                }
            })
            return AnonymousDisposable {
                self.removeObserverWithHandle(observeStatus)
            }
        }
    }
}

extension ObservableType where E : FIRStorageUploadTask {
    func rx_storageStatus() -> Observable<(FIRStorageTaskSnapshot, FIRStorageTaskStatus)> {
        return self.flatMap { (uploadTask: FIRStorageUploadTask) -> Observable<(FIRStorageTaskSnapshot, FIRStorageTaskStatus)> in
            let progressStatus = uploadTask.rx_observeStatus(.Progress)
            let successStatus = uploadTask.rx_observeStatus(.Success)
            let failureStatus = uploadTask.rx_observeStatus(.Failure)
            
            let merged = Observable.of(progressStatus, successStatus, failureStatus).merge()
            return merged
        }
    }
}

extension ObservableType where E : FIRStorageDownloadTask {
    func rx_storageStatus() -> Observable<(FIRStorageTaskSnapshot, FIRStorageTaskStatus)> {
        return self.flatMap { (downloadTask: FIRStorageDownloadTask) -> Observable<(FIRStorageTaskSnapshot, FIRStorageTaskStatus)> in
            let progressStatus = downloadTask.rx_observeStatus(.Progress)
            let successStatus = downloadTask.rx_observeStatus(.Success)
            let failureStatus = downloadTask.rx_observeStatus(.Failure)
            
            let merged = Observable.of(progressStatus, successStatus, failureStatus).merge()
            return merged
        }
    }
}
