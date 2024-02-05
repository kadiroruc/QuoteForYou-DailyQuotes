//
//  ViewModel.swift
//  AA
//
//  Created by Abdulkadir Oruç on 3.02.2024.
//

import Foundation
import UIKit
import UserNotifications
import CoreData


protocol ViewModelDelegate: AnyObject{
    func didUpdate()
}

class ViewModel: NSObject, UNUserNotificationCenterDelegate{
    weak var delegate: ViewModelDelegate?
    
    private var quote: Quote = []
    private var errorMessage: Error?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var favoriteQuotes = [QuoteDataModel]()
    
    
    
    override init() {
        super.init()
        
        //UNUserNotificationCenter.current().delegate = self
        scheduleNotification()
        checkLastUpdateDate()
        
        loadFavoriteQuotes()
        
        
    }


    
    func checkLastUpdateDate(){
        
        let userDefaults = UserDefaults.standard
        
//        // UserDefaults'taki tüm değerleri temizleme
//        if let bundleID = Bundle.main.bundleIdentifier {
//            UserDefaults.standard.removePersistentDomain(forName: bundleID)
//        }

        
        
        if let previousUpdateTime = userDefaults.object(forKey: "previousUpdateTime") as? Date{
            
            let currentDate = Date()
            let calendar = Calendar.current
            
            print("Önceki yükleme tarihi: \(previousUpdateTime)")
            print("Şuanki zaman:\(currentDate)")
            if let difference = calendar.dateComponents([.hour], from: previousUpdateTime, to: currentDate).hour, difference >= 24{
                loadData()
                
                var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: currentDate)
                dateComponents.hour = 9
                dateComponents.minute = 00
                dateComponents.second = 00
                
                if let previousUpdateDate = calendar.date(from: dateComponents){
                    print("Yeni son yükleme tarihi\(previousUpdateDate)")
                    userDefaults.set(previousUpdateDate, forKey: "previousUpdateTime")
                }
                
                print("24 saat geçti ve veriler yüklendi.")
                
            }else{
                print("24 saat geçmedi")
            }
            
        }else{
            
            let currentDate = Date()
            let calendar = Calendar.current
            
            var dateComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
            dateComponents.day! -= 1
            dateComponents.hour = 9
            dateComponents.minute = 00
            dateComponents.second = 00
            
            if let previousUpdateDate = calendar.date(from: dateComponents){
                userDefaults.set(previousUpdateDate, forKey: "previousUpdateTime")
            }
        }
        

        

        

    }
    
    func scheduleNotification(){
        let content = UNMutableNotificationContent()
        content.title = "App name"
        content.body = "Your Daily Quote is Ready"
        content.sound = .default
        
        
        var dateComponents = DateComponents()
        dateComponents.hour = 09
        dateComponents.minute = 00
        dateComponents.second = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        
        // Bildirimi oluştur
        let request = UNNotificationRequest(identifier: "reminderNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Bildirim eklenirken bir hata oluştu: \(error.localizedDescription)")
            } else {
                print("Bildirim planı başarıyla eklendi.")
            }
        }
    }
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        self.loadData()
//    }
    
    
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

//MARK: - Core Data
extension ViewModel{
    func saveFavoriteQuote(quoteContent: String, quoteAuthor: String){
        let quoteDataModel = QuoteDataModel(context: self.context)
        quoteDataModel.content = quoteContent
        quoteDataModel.author = quoteAuthor
        
        self.favoriteQuotes.append(quoteDataModel)
        
        do {
            try context.save()
        } catch {
            print("Error saving favorite Quotes \(error)")
        }
    }
    
    func loadFavoriteQuotes(){
        
        let request: NSFetchRequest<QuoteDataModel> = QuoteDataModel.fetchRequest()
        
        do{
            favoriteQuotes = try context.fetch(request)
        }catch{
            print("Error loading favorite Quotes \(error)")
        }
    }
    
    func getFavoriteQuotes() -> [QuoteDataModel]{
        
        return favoriteQuotes
    }
}
