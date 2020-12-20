//
//  DataProvider.swift
//  Networking
//
//  Created by Александр Майко on 01.11.2020.
//  Copyright © 2020 Александр Майко. All rights reserved.
//

import UIKit

class DataProvider: NSObject { //необходимо создавать класс для загрузки данных в фоновом режиме
    
    var fileLocation: ((URL) ->())? //захватывает расположение файла
    var onProgress: ((Double) ->())?// захватывает прогресс
    
   private var downloadTask: URLSessionDownloadTask!//объект используется для настройки сессии
    
    private lazy var bgSession : URLSession = { //настройка параметров конфигурации для фоновой загрузки!!!
        var config = URLSessionConfiguration.background(withIdentifier: "com.AlexMike.Networking")
        config.isDiscretionary = true // могут ли фоновые задачи быть запланированы по умолчанию системой самостоятельно
        config.waitsForConnectivity = true //ожидание подключения к сети (если ее не было на момент начала загрузки)
        config.timeoutIntervalForResource = 300 //указывает время, которые будет выделено на ожидание,в секундах
        config.sessionSendsLaunchEvents = true // по завершению загрузки приложение запустится в фоновом режиме, так же запускает метод handleEventsForBackgroundURLSession в AppDelegate !!!
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
        
    }()
    
    func startDownload() { // метод для загрузки данных
        if let url = URL(string: "https://speed.hetzner.de/100MB.bin") {
            downloadTask = bgSession.downloadTask(with: url)//передаем сессии ранее сделаные настройки
            downloadTask.earliestBeginDate = Date().addingTimeInterval(3)//загрузка начнется через 3 секунды
            downloadTask.countOfBytesClientExpectsToSend = 512
            downloadTask.countOfBytesClientExpectsToReceive = 100 * 1024 * 1024
            downloadTask.resume()
        }
    }
    
    func stopDownload() {// метод отмены загрузки
        downloadTask.cancel()
    }

}

extension DataProvider : URLSessionDelegate{
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        
        DispatchQueue.main.async {
            guard
                let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let completionHandler = appDelegate.bgSessionCompletionHandler //присваиваем переменной значение захваченное идентификатора сессии из appDelegate
            else {return}
            
            appDelegate.bgSessionCompletionHandler = nil // обнуляем значение идентификатора
            completionHandler()// и вызываем исходный блок , чтобы уведомить систему что загрузка была завершена
        }
    }// срабатывает по завершении всех фоновых задач с нашим идентификатором "com.AlexMike.Networking", так же изменения произошли в файле appDelegate
}
extension DataProvider: URLSessionDownloadDelegate {//для получения ссылки на загруженный файл
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Did finish downloading: \(location.absoluteString)")
        DispatchQueue.main.async {
            self.fileLocation?(location)// передаем информацию о хранение файла
        }
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {//для отображения хода процесса загрузки!!!!
        
        guard totalBytesExpectedToWrite != NSURLSessionTransferSizeUnknown else {return}
            let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        print ("download progress \(progress)")
        
        DispatchQueue.main.async {
            self.onProgress?(progress)//захватываем значение процесса
        }
    }
}
