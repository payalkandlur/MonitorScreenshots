//
//  MonitorScreenshot.swift
//  MonitorScreenshot
//
//  Created by Payal Kandlur on 31/03/24.
//

import Photos
import UserNotifications

class MonitorScreenshot: NSObject, ObservableObject {
    private let photoLibrary = PHPhotoLibrary.shared()
    private var latestScreenshotAsset: PHAsset? // for the latest screenshot
    
    override init() {
        super.init()
        photoLibrary.register(self)
    }
    
    deinit {
        photoLibrary.unregisterChangeObserver(self)
    }
    
    func sendLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Screenshot Detected"
        content.body = "Someone took a screenshot outside of the app."
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
}

extension MonitorScreenshot: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.global().async {
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
            
            fetchResult.enumerateObjects { asset, _, _ in
                if asset.mediaSubtypes.contains(.photoScreenshot) {
                    if let latestAsset = self.latestScreenshotAsset,
                       let creationDate = asset.creationDate,
                       let latestCreationDate = latestAsset.creationDate,
                       creationDate > latestCreationDate {
                        self.latestScreenshotAsset = asset
                        DispatchQueue.main.async {
                            self.sendLocalNotification()
                        }
                    } else if self.latestScreenshotAsset == nil {
                        self.latestScreenshotAsset = asset
                        DispatchQueue.main.async {
                            self.sendLocalNotification()
                        }
                    } 
                }
            }
        }
    }
}
