import UserNotifications
import AVFoundation

class NotificationService: UNNotificationServiceExtension {
    
    var player: AVPlayer?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        let content = request.content
        let userInfo = content.userInfo
        let songURL = userInfo["songURL"] as? String
        
        if let songURL = songURL, let url = URL(string: songURL) {
            player = AVPlayer(url: url)
            player?.play()
        }
        
        contentHandler(content)
    }
    
    override func serviceExtensionTimeWillExpire() {
        player?.pause()
    }
}
