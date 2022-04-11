//
//  AddToFavViewController.swift
//  CodingChallengeAPOD
//
//  Created by Gurleen kaur on 9/4/22.
//

import UIKit
import Kingfisher
import youtube_ios_player_helper

class AddFavouritesViewController: UIViewController  {
    
    // MARK: - Variables
    var isSearching = false
    var astroPicture: AstroPictureOfTheDay?
    var viewModel : AddFavouriteViewModel?
    
    // MARK: - IBOutlets
    @IBOutlet weak var selectDateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var astroImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var explainationLabel: UILabel!
    @IBOutlet weak var addToFavouritesButton: UIButton!
    @IBOutlet weak var playerView: YTPlayerView!
    
    // MARK: - View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDatePicker()
        configureAddToFavouriteButton()
        configureUI()
        
        self.viewModel = AddFavouriteViewModel.init(delegate: self)

        self.navigationItem.title = Constants.Strings.kAddToFavouriteVCTitle
        selectDateLabel.isUserInteractionEnabled = false
        
    }
    
    // MARK: - IBActions
    @IBAction func addToFavouritesButtonAction(_ sender: UIButton) {
        if sender.imageView?.image == Constants.Images.kFavouriteUnselected {
            if let astroDetails  = self.astroPicture {
                RealmManager.init().saveObjects(objs:  astroDetails)
                DispatchQueue.main.async {
                    self.setImageForFavourite(image: Constants.Images.kFavouriteSelected)
                    self.showAlert(alertMessage: Constants.Alerts.kAlerPictureAdded)

                }
            }}
    }
    
    // MARK: - Functions
    
    func configureUI() {
        DispatchQueue.main.async {
            if let astroDetails = self.astroPicture{
                if let url = astroDetails.url{
                    //set APOD url according to media type
                    if astroDetails.media_type == Constants.MediaType.image.getValue() {
                        self.playerView.isHidden = true
                        self.astroImageView.isHidden = false
                        if let imgurl = URL(string: url) {
                            self.astroImageView.loadImage(imgurl)
                        }
                    } else if astroDetails.media_type == Constants.MediaType.video.getValue() {
                        self.playerView.isHidden = false
                        self.astroImageView.isHidden = true
                        self.playYoutubeVideoWith(url: url)
                    }
                    
                } else {
                    self.astroImageView.image = UIImage(named:Constants.Images.kImgPlaceHolder)
                }
                
                // set title of the APOD
                self.titleLabel.text = astroDetails.title
                
                // set explaination of the APOD
                self.explainationLabel.text = astroDetails.explanation
                
                // set date of the current APOD if date is available and in the correct format
                if let dateString = astroDetails.date {
                    if let date = dateString.date(format: Constants.Strings.kDateFormat) {
                        self.datePicker.date = date
                        
                    }
                }
            }
        }
    }
    
    
    func configureAddToFavouriteButton() {
        //Handle the visibility of addFavouritesbutton
        if isSearching == true {
            self.addToFavouritesButton.isHidden = true
        } else {
            self.datePicker.isUserInteractionEnabled = false
            self.selectDateLabel.isHidden = true
            self.setImageForFavourite(image: Constants.Images.kFavouriteSelected)
        }
    }
    
    //extract the videoID from the video url and load it in the ytplayer
    func playYoutubeVideoWith(url: String) {
        let components = url.components(separatedBy: "/")
        if let videoId = components.last {
            playerView.load(withVideoId: videoId)
            playerView.playVideo()
        }
    }
    
    //add behaviour to the datePicker
    func configureDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.date = Date()
        datePicker.locale = .current
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(handleDateSelection), for: .valueChanged)
        datePicker.maximumDate = Date()
        if self.isSearching == true {
            self.datePicker.isUserInteractionEnabled = true
        } else {
            self.datePicker.isUserInteractionEnabled = false
        }
    }
    
    //called when user successfully selects a date
    @objc func handleDateSelection() {
        presentedViewController?.dismiss(animated: true, completion: {
            let dateString = self.datePicker.date.toString()
            self.checkIfItemExists(date: dateString)
            self.selectDateLabel.isHidden = true
        })
    }
    
    //checks if the APOD for the same date exists in the database.
    func checkIfItemExists(date: String) {
        let itemExists = RealmManager.init().objectExists(id: date)
        if itemExists {
            self.setImageForFavourite(image: Constants.Images.kFavouriteSelected)
            if let astro = RealmManager.init().getObject(id: date){
                self.astroPicture =  astro
                self.configureUI()
            }
        } else {
            fetchAstroPictureFor(date: date)
        }
    }
    
    func fetchAstroPictureFor(date: String) {
        let params = [Constants.Strings.kParamDate: date, Constants.Strings.kParamAPIKey: Constants.Strings.kApIKey]
        self.viewModel?.fetchPictureOfTheDay(params: params, vc: self)
    }
    
    //update the image for the addFavouritesButton
    func setImageForFavourite(image: UIImage?) {
        DispatchQueue.main.async {
            if (self.addToFavouritesButton.isHidden){
                self.addToFavouritesButton.isHidden = false
            }
            self.addToFavouritesButton.setImage(image , for: .normal)
        }
    }
}

//MARK: - PictureDelegate
//Communication with the ViewModel
extension AddFavouritesViewController: PictureDelegate {
    //fetches data from API to present controller
    func pictureDetails(data: AstroPictureOfTheDay?) {
        astroPicture = data
        setImageForFavourite(image: Constants.Images.kFavouriteUnselected)
        configureUI()
    }
    
    func showAlert(alertMessage: String) {
        CommonFunctions.showAlert(title: Constants.Alerts.kAlertAstronomyTitle, message: alertMessage, controller: self)
    }
    
    func showLoader() {
        showSpinner(onView: view)
    }
    
    func hideLoader() {
        removeSpinner()
    }
}
