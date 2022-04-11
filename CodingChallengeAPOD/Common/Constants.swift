//
//  Constants.swift
//  CodingChallengeAPOD
//
//  Created by Gurleen kaur on 10/4/22.
//

import Foundation
import UIKit
final class Constants {
    
    
    enum MediaType : String {
        case video = "video"
        case image = "image"
        func getValue() -> String {
        return self.rawValue
        }
    }
    
    struct Segues{
       static let kSegueHomeToFav = "AddFav"
    }
    
    struct ServiceUrl{
       static let kFetchAPOD = "https://api.nasa.gov/planetary/apod"
    }
    
    struct Strings{
        
        static let kAddToFavouriteVCTitle = "Picture of the Day"
        static let kHomeVCTitle = "My Favourites"
        static let kApIKey = "YZujnNNTsRGVzf2ovfCn1lztcQZt9C4zIMGKEzAj"
        static let kParamAPIKey = "api_key"
        static let kParamDate = "date"
        static let kDateFormat = "yyyy-MM-dd"
        static let kReusableCell = "cell"
        static let kOkay =  "OK"
    
    }
    
    struct Images{
        
        static let kImgPlaceHolder = "PlaceholderIcon"
        static let kImgFavourite = "FavIcon"
        static let kFavouriteUnselected = UIImage(named:  "star_Icon")
        static let kFavouriteSelected = UIImage(named:  "starFilled_Icon")
       
    }
    
    struct Alerts{
        static let kAlertAstronomyTitle = "Astronomy Picture of the Day"
        static let kAlerPictureAdded = "Item Added to Favourites"
        static let kInternetConnection = "Please connect to the internet"
        
        static let kAlertRemoveFromFav = "Are you sure you want to remove from favourites?"
        static let kYes = "Yes"
        static let kNo = "No"
    }
}
