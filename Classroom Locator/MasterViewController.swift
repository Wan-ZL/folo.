
import UIKit
import Alamofire
import os.log

class MasterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
  
  // MARK: - Properties
  @IBOutlet var tableView: UITableView!
  
  var detailViewController: DetailViewController? = nil
  var filteredLocations = [UALocation]()
    var savedLocations = [UALocation]()
  let searchController = UISearchController(searchResultsController: nil)
  
  // MARK: - View Setup
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    // Setup the Search Controller
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search Locations with course info"
    navigationItem.searchController = searchController
    definesPresentationContext = true
    
    // Setup the Scope Bar
    searchController.searchBar.delegate = self
    

    if let splitViewController = splitViewController {
      let controllers = splitViewController.viewControllers
      detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
    }
    tableView.delegate = self
    tableView.dataSource = self
    
    if let temp = loadLocations(){
     savedLocations = temp
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if splitViewController!.isCollapsed {
      if let selectionIndexPath = tableView.indexPathForSelectedRow {
        tableView.deselectRow(at: selectionIndexPath, animated: animated)
      }
    }
    super.viewWillAppear(animated)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Table View
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if isFiltering() {
      return filteredLocations.count
    }
    
    return savedLocations.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let location: UALocation
    if isFiltering(){
        location = filteredLocations[indexPath.row]
    }
    else{
        location = savedLocations[indexPath.row]
    }
    cell.textLabel!.text = "\(location.courseCode) \(location.courseNum), \(location.sectionNum)-\(location.courseType)"
    cell.detailTextLabel!.text = location.locationName
    return cell
  }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            savedLocations.remove(at: indexPath.row)
            saveLocations()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
  
  // MARK: - Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDetail" {
      if let indexPath = tableView.indexPathForSelectedRow {
        let location: UALocation
        if isFiltering(){
            location = filteredLocations[indexPath.row]
            savedLocations.append(location)
            saveLocations()
        }
        else{
            location = savedLocations[indexPath.row]
        }
        let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
        controller.detailLocation = location
        controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        controller.navigationItem.leftItemsSupplementBackButton = true
      }
    }
  }
  
  // MARK: - Private instance methods
  
  func filterContentForSearchText(_ searchText: String) {
    // use search API
    if searchText.count == 0{
        self.filteredLocations.removeAll()
        tableView.reloadData()
        return
    }
    
    Alamofire.request("https://cl.simino.xyz/v1/course/getCourse", method : .get, parameters: ["mass":searchText]).responseJSON { response in
        debugPrint(response)

        self.filteredLocations.removeAll()
        if let json = response.result.value as! NSDictionary? {
            if let result = json["result"] as! NSArray? {
                if result.count > 0 {
                    for one in result {
                        let oneDic = one as! NSDictionary
                        self.filteredLocations.append(UALocation(locationName : String(describing: oneDic["location"]!).uppercased(), courseCode : String(describing: oneDic["subject"]!).uppercased(), courseNum : String(describing: oneDic["catalogNumber"]!), sectionNum : String(describing: oneDic["section"]!), courseType : String(describing: oneDic["courseType"]!), roomNo: String(describing: oneDic["room"]!)))
                    }
                    print("\(result[0])")
                }
            }
            for (key, value) in json {
                print("Value: \(value) for key: \(key)")
            }
        }
        print("RELOADING")
        self.tableView.reloadData()
    }
  
  }
  
  func searchBarIsEmpty() -> Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }
  
  func isFiltering() -> Bool {
    let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
    return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
  }
    
    
    private func saveLocations(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(savedLocations, toFile: UALocation.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Locations successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save locations...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadLocations() -> [UALocation]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: UALocation.ArchiveURL.path) as? [UALocation]
    }
    
}

extension MasterViewController: UISearchBarDelegate {
  // MARK: - UISearchBar Delegate
  func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    filterContentForSearchText(searchBar.text!)
  }
}

extension MasterViewController: UISearchResultsUpdating {
  // MARK: - UISearchResultsUpdating Delegate
  func updateSearchResults(for searchController: UISearchController) {
    //let searchBar = searchController.searchBar
    //let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
    filterContentForSearchText(searchController.searchBar.text!)
  }
}
