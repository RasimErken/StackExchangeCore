//
//  ImageLoader.swift
//  StackExchangeCore
//
//  Created by rasim rifat erken on 15.09.2022.
//

import Foundation
import UIKit

final class ImageService {
    func image(for data:String , completion :@escaping (UIImage?) -> Void ) ->Cancellable{
        guard let url = URL(string:data) else {return print("aaa") as! Cancellable }
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            var image:UIImage?
            defer {
                DispatchQueue.main.async {
                    completion(image)
                }
               
            }
            if let data = data {
                image = UIImage(data: data)
            }
        }
        dataTask.resume()
        return dataTask
        
    }
}
