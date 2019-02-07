//
//  NetworkState.swift
//  UpcomingMovies
//
//  Created by Erika Bueno on 07/02/19.
//  Copyright © 2019 8sys. All rights reserved.
//

import Foundation
import Alamofire

class NetworkState {
    
    class func isConnected() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
}
