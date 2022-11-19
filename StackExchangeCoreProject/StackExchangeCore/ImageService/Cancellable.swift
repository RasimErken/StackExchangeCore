//
//  Cancellable.swift
//  StackExchangeCore
//
//  Created by rasim rifat erken on 15.09.2022.
//

import Foundation
import UIKit

protocol Cancellable {
    func cancel()
}

extension URLSessionTask : Cancellable {
    
}
