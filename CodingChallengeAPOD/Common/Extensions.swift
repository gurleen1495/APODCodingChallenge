//
//  Extensions.swift
//  CodingChallengeAPOD
//
//  Created by Gurleen kaur on 11/4/22.
//

import Foundation
import UIKit

var vSpinner : UIView?

extension Date {
    func toString(format:String = "yyyy-MM-dd") -> String {
        let df:DateFormatter = DateFormatter();
        df.dateFormat = format;
        df.locale = Locale(identifier: "en_US_POSIX")
        // df.timeZone = TimeZone.current
        return df.string(from: self)
    }
}

extension String {
    func date(format: String = "YYYY-MM-dd'T'HH:mm:ss.SSS'Z'") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: self)
    }
}

extension UIImageView{
   func loadImage(_ url : URL?) {
       var kf = self.kf
        kf.indicatorType = .activity
       kf.setImage(with: url)
   }

   func loadImage(_ url : String?) {
       guard let urlStr = url else {return}
       self.kf.setImage(with: URL.init(string: urlStr))
   }
}

extension UIViewController{
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView()
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}
