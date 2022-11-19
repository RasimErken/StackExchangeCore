//
//  ViewModel.swift
//  StackExchangeApı
//
//  Created by rasim rifat erken on 14.09.2022.
//

import Foundation


class QuestionViewModel {
    
    
   
    
    func getALLData(page:Int , completion: @escaping (Result<QuestionResponse, Error>) -> Void) {
        let urlString = questionUrl + String(page) + stackoverflow
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { ( data, response, error ) in
            guard let data = data else { return }
            let jsonDecoder = JSONDecoder()
            do {
                let finalData = try jsonDecoder.decode(QuestionResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(finalData))
                }
                
            } catch  {
                print(error, "Couldn't be parsed correctly Question")
            }

        } .resume()
        
    }
 
}
