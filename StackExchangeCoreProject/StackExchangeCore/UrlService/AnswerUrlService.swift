//
//  AnswerViewModel.swift
//  StackExchangeApı
//
//  Created by rasim rifat erken on 15.09.2022.
//

import Foundation

class AnswerViewModel {
    
    func getALLData(page:Int , completion: @escaping (Result<GetAnsweredByResponse, Error>) -> Void) {
        let urlString = answerUrl + String(page) + stackoverflow
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { ( data, response, error ) in
            guard let data = data else { return }
            let jsonDecoder = JSONDecoder()
            do {
                let finalData = try jsonDecoder.decode(GetAnsweredByResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(finalData))
                }
            } catch  {
                print(error, "Couldn't be parsed correctly Answer")
            }

        } .resume()
        
    }
 
}
