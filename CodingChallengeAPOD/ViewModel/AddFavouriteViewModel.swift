//
//  AddFavouriteViewModel.swift
//  CodingChallengeAPOD
//
//  Created by Gurleen kaur on 11/4/22.
//

import Foundation
import UIKit

//Communication with ViewController
protocol PictureDelegate: AnyObject {
    func pictureDetails(data: AstroPictureOfTheDay?)
    func showLoader()
    func hideLoader()
    func showAlert(alertMessage: String)
}

class AddFavouriteViewModel {
    
    //PictureDelegate
    weak var delegate:PictureDelegate?
   
    init(delegate: PictureDelegate) {
        self.delegate = delegate
    }
    
    //API call to APOD
    func fetchPictureOfTheDay(params: [String:String], vc: UIViewController){
        
        self.delegate?.showLoader()
        ServiceManager.sharedInstance.sendRequest(Constants.ServiceUrl.kFetchAPOD, parameters: params, vc: vc) { values, error in
           self.delegate?.hideLoader()
            if error == nil {
                if let value = values {
                    let astroPicture = JSONDecoder().decodeObject(AstroPictureOfTheDay.self, from: value)
                    self.delegate?.pictureDetails(data: astroPicture)
                }
            } else {
                guard let apiError = error else{ return}
                self.delegate?.showAlert(alertMessage: apiError)
            }
        }
    }
    
}
