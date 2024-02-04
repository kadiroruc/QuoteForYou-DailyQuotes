//
//  ViewModel.swift
//  AA
//
//  Created by Abdulkadir Oruç on 3.02.2024.
//

import Foundation
import UserNotifications

protocol ViewModelDelegate: AnyObject{
    func didUpdate()
}

class ViewModel{
    weak var delegate: ViewModelDelegate?
    
    private var quote: Quote = []
    private var errorMessage: Error?
    
    var timer: Timer?
    
    init() {
        checkLastNotificationDate()
    }
    
    func checkLastNotificationDate(){
        let userDefaults = UserDefaults.standard
        if let lastNotificationDate = userDefaults.object(forKey: Constants.shared.lastNotificationDateKey) as? Date {
            // Son bildirim gönderme tarihini al
            let currentDate = Date()
            let calendar = Calendar.current
            if let differenceInHours = calendar.dateComponents([.second], from: lastNotificationDate, to: currentDate).second, differenceInHours >= 30 {
                loadData()
                // Son bildirimden 24 saat veya daha fazla zaman geçti, işlemi gerçekleştir
                print("24 saat geçti! İşlem yapılıyor ve bildirim gönderiliyor.")
                // İşlemi gerçekleştir ve yeni bildirimi gönder
                performActionAndSendNotification()
                // Son bildirim tarihini güncelle
                userDefaults.set(currentDate, forKey: Constants.shared.lastNotificationDateKey)
            } else {
                print("Henüz 24 saat geçmemiş, işlem yapma.")
            }
        } else {
            loadData()
            // İlk kez bildirim gönderiliyor, işlemi gerçekleştir ve bildirim gönder
            print("İlk kez bildirim gönderiliyor.")
            performActionAndSendNotification()
            // Son bildirim tarihini kaydet
            userDefaults.set(Date(), forKey: Constants.shared.lastNotificationDateKey)
        }
    }
    
    func performActionAndSendNotification() {
        // İşlemi gerçekleştir
        print("İşlem gerçekleştirildi.")
        
        // Bildirim oluştur
        createNotification()
    }
    
    func createNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Hatırlatma"
        content.body = "Bir şeyler yapma zamanı!"
        content.sound = .default
        
        // Bildirimi hemen göster
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) // Hemen göster, tekrar etme
        let request = UNNotificationRequest(identifier: "reminderNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Bildirim eklenirken bir hata oluştu: \(error.localizedDescription)")
            } else {
                print("Bildirim başarıyla eklendi.")
            }
        }
    }
    
    
    
    func loadData(){
        NetworkService.getQuote {[weak self] result in
            switch result{
            case let .success(quote):
                self?.quote = quote
                self?.delegate?.didUpdate()
            
            case let .failure(error):
                self?.quote = []
                self?.errorMessage = error
            }
        }
    }
    func getQuote() -> QuoteModel{
        return quote[0]
    }

    
}
