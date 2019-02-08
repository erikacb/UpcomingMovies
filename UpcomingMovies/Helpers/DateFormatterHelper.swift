//
//  DateFormatterHelper.swift
//  UpcomingMovies
//
//  Created by Erika Bueno on 07/02/19.
//  Copyright © 2019 8sys. All rights reserved.
//

import Foundation

class DateFormatterHelper {
    
    class func convertDate(_ date: String) -> String {
        if date != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: date)
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.string(from: date!)
        } else {
            return "No release date available"
        }
        
    }
    
}
