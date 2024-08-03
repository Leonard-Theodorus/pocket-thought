//
//  PhilosopherAPIService.swift
//  Pocket Thought
//
//  Created by Alonica🐦‍⬛🐺 on 04/07/24.
//

import Foundation
import UIKit

class PhilosopherAPIService {
    let apiService : APIService
    var urlQueryItem = URLQueryItem(name: "search", value: nil)
    var delegate : PhilosopherAPIDelegate?
    
    //MARK: INIT WITH MAIN SERVICE
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func getPhilosopherData(queryName : String) async{
        var urlComponents = URLComponents(string: apiService.baseURL)
        urlQueryItem.value = queryName
        urlComponents?.queryItems = [urlQueryItem]
        guard let urlComponents, let url = urlComponents.url else { return }
        var fetchedPhilosophers : [PhilosopherDTO] = []
        var readyPhilosophers : [Philosopher] = []
        do{
            let (data, _) = try await apiService.sharedSession.data(from: url)
            let JSONDecoder = JSONDecoder()
            let fetchResults = try JSONDecoder.decode(PhilosopherResult.self, from: data)
            fetchedPhilosophers = fetchResults.results
            for philosopher in fetchedPhilosophers {
                var newPhilosopher = Philosopher(from: philosopher)
                guard let photoUrl = URL(string: philosopher.photoURLString) else {continue}
                //TODO: Create ERROR
                let philosopherPhoto = await downloadImage(for: photoUrl)
                guard let photo = UIImage(data: philosopherPhoto) else {continue}
                newPhilosopher.photo = photo
                readyPhilosophers.append(newPhilosopher)
            }
            delegate?.didFinishLoadingData(data: readyPhilosophers)
        }
        catch (let err){
            print(err.localizedDescription)
        }
    }
    
    private func downloadImage(for url : URL) async -> Data{
        var imageData : Data = Data()
        do{
            let (data, _) = try await apiService.sharedSession.data(from: url)
            imageData = data
        }
        catch (let err){
            print(err.localizedDescription)
        }
        return imageData
    }
    
}
