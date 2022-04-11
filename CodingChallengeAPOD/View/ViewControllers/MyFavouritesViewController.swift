//
//  MyFavouritesViewController.swift
//  CodingChallengeAPOD
//
//  Created by Gurleen kaur on 10/4/22.
//

import UIKit

class MyFavouritesViewController: UIViewController {
    
    //MARK: - Variables
    var myFavouritesList = [AstroPictureOfTheDay]()
    
    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noFavouritesFound: UILabel!
    
    //MARK: - View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.navigationItem.title = Constants.Strings.kHomeVCTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getListOfFavourites()
    }
    
    //MARK: - View Functions
    func getListOfFavourites() {
        if let getObjectFromDb = RealmManager.init().getObjects(type: AstroPictureOfTheDay.self) {
            if !getObjectFromDb.isEmpty {
                for element in getObjectFromDb{
                    if let data = element as? AstroPictureOfTheDay{
                        if !myFavouritesList.contains(data){
                            self.myFavouritesList.append(data)
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        configureNoFavouriteAPODLabel()
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == Constants.Segues.kSegueHomeToFav) , let viewController = segue.destination as? AddFavouritesViewController {
            //favourite item selected
            if let index = self.tableView.indexPathForSelectedRow {
                viewController.isSearching = false
                viewController.astroPicture = myFavouritesList[index.row]
            } else {
                //adding an item
                viewController.isSearching = true
            }
        }
    }
}

//MARK: - TableView Delegates , DataSource

extension MyFavouritesViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFavouritesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyFavouritesTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.Strings.kReusableCell, for: indexPath) as! MyFavouritesTableViewCell
        cell.lblTitle.text = myFavouritesList[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: Constants.Segues.kSegueHomeToFav, sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            CommonFunctions.showAlertActionView(title: Constants.Alerts.kAlertAstronomyTitle,
                                                message: Constants.Alerts.kAlertRemoveFromFav,
                                                controller: self) {
                let obj = self.myFavouritesList[indexPath.row]
                RealmManager.init().deleteObject(objs: obj)
                self.myFavouritesList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                self.configureNoFavouriteAPODLabel()
            }
        }
    }
    
    func configureNoFavouriteAPODLabel() {
        if self.myFavouritesList.count == 0 {
            noFavouritesFound.isHidden = false
        } else {
            noFavouritesFound.isHidden = true
        }
    }
}
