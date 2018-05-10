import UIKit

class RootViewController: UITableViewController {

    // MARK: - Propertie
    var data:[(category: String, name: String)] = []
    var filteredData:[(category: String, name: String)] = []
    let searchController = UISearchController(searchResultsController: nil)

    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()

        data.append((category:"Chocolate", name:"Chocolate Bar"))
        data.append((category:"Chocolate", name:"Chocolate Chip"))
        data.append((category:"Chocolate", name:"Dark Chocolate"))
        data.append((category:"Hard", name:"Lollipop"))
        data.append((category:"Hard", name:"Candy Cane"))
        data.append((category:"Hard", name:"Jaw Breaker"))
        data.append((category:"Other", name:"Caramel"))
        data.append((category:"Other", name:"Sour Chew"))
        data.append((category:"Other", name:"Gummi Bear"))
        data.append((category:"Other", name:"Candy Floss"))
        data.append((category:"Chocolate", name:"Chocolate Coin"))
        data.append((category:"Chocolate", name:"Chocolate Egg"))
        data.append((category:"Other", name:"Jelly Beans"))
        data.append((category:"Other", name:"Liquorice"))
        data.append((category:"Hard", name:"Toffee Apple"))
        filteredData = data

        // Setup the Refresh Control
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Puxe para atualizar")
        self.refreshControl!.addTarget(self, action: #selector(updateDataContent), for: .valueChanged)

        // Setup the Search Controller
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Pesquisar"
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false;

        // Setup the Scope Bar
        searchController.searchBar.delegate = self
        searchController.searchBar.scopeButtonTitles = ["Chocolate", "Hard", "Other"]
    }
    
    @objc func updateDataContent() {
        self.tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            self.refreshControl!.endRefreshing()
        })
    }

    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    func filterContentForSearchText(_ searchText: String) {
        filteredData = data.filter({( itemData : (category: String, name: String)) -> Bool in
            if (self.searchBarIsEmpty()) {
                return true
            } else {
                return itemData.name.lowercased().contains(searchText.lowercased())
            }
        })
        self.tableView.reloadData()
    }

    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let itemData = filteredData[indexPath.row]
        cell.textLabel!.text = itemData.name
        cell.detailTextLabel!.text = itemData.category
        return cell
    }
}

// MARK: - UISearchBar Delegate
extension RootViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.filterContentForSearchText(searchBar.text!)
    }
}

// MARK: - UISearchResultsUpdating Delegate
extension RootViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        self.filterContentForSearchText(searchBar.text!)
    }
}
