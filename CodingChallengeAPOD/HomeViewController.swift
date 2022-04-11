//
//  HomeViewController.swift
//  CodingChallengeAPOD
//
//  Created by Gurleen kaur on 9/4/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - Variables
    var myFayourites = [AstroPictureOfTheDay]()
    
    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNoFavs: UILabel!
    
    //MARK: - View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
       self.tableView.rowHeight = UITableView.automaticDimension
        self.navigationItem.title = Constants.Strings.kHomeTitle
      
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.getListOfFavourites()
    }
    //MARK: - View Functions
    func getListOfFavourites(){
        if let getObject = RealmManager.init().getObjects(type: AstroPictureOfTheDay.self){
            if getObject.isEmpty{
                lblNoFavs.isHidden = false
            }else{
                lblNoFavs.isHidden = true
                for element in getObject{
                    if let data = element as? AstroPictureOfTheDay{
                        if !myFayourites.contains(data){
                        self.myFayourites.append(data)
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == Constants.Segues.kSegueHomeToFav) , let viewController = segue.destination as? AddToFavViewController {
            
            if let index = self.tableView.indexPathForSelectedRow {
                viewController.isSearching = false
                viewController.astroPicture = myFayourites[index.row]
            }else{
                viewController.isSearching = true
            }
            
        }
        
    }
}

  //MARK: - TableView Delegates , DataSource

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFayourites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MyFavouritesTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.Strings.kReusableCell, for: indexPath) as! MyFavouritesTableViewCell
        cell.lblTitle.text = myFayourites[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: Constants.Segues.kSegueHomeToFav, sender: indexPath)
    }
    
}
