// Populating table data
// @Aswin Sampath

import UIKit

class TableViewController: UITableViewController, UISearchBarDelegate{
    
    let weatherData = CityDataLoader().cityData
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    //This variable is required for search functionality
    var data: [CityAttributes]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        data = weatherData
        
    }
    
    //This method returns the total count of the data for identfying the number of rows required in tableview
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    //This method sets teh content of each row in the tableview
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:  "cell", for: indexPath)
        let state = data[indexPath.row].state != "" ? (data[indexPath.row].state+", "): ""
        let name = data[indexPath.row].name != "-" ? (data[indexPath.row].name) + ", " : ""
        cell.textLabel?.text = name + state + data[indexPath.row].country
        return cell;
    }
    
    /*This method is called when a row is clicked, this will populate latitute, longitude, cityName of ViewController class and
    navigates to the first screen
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let city = data[indexPath.row]
        
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                  
        viewController.lat = city.coord.lat
        viewController.lon = city.coord.lon
        viewController.isNavSelected = true
        viewController.inputCity = city.name
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    //This method performs search bar functionality
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        data = []
        
        //When searchbar is empty initially or the text is erased after typing, original list of data is displayed
        if searchText == ""{
            data = weatherData
        }
        else{
            
            for cityData in weatherData {
                if cityData.name.lowercased().contains(searchText.lowercased()){
                    data.append(cityData)
                }
            }
        }
        
        self.tableView.reloadData()
    }
}
