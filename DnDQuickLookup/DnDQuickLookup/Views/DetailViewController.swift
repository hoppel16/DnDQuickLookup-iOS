//
//  DetailViewController.swift
//  DnDQuickLookup
//
//  Created by Hunter Oppel on 2/3/21.
//

import UIKit

class DetailViewController: UIViewController {

    var selectedCategory: String?
    var networkAPI: Networking?

    // #TODO: Move this into CoreData
    var spellList = [String]()
    var spells: [String:CategoryResult] = [:]

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        if let selectedCategory = selectedCategory {
            fetchCategory(selectedCategory)
        }
    }

    private func fetchCategory(_ category: String) {
        guard let networkAPI = networkAPI else { return }
        networkAPI.fetchCategoryFromAPI(category) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    for result in results.results {
                        if (self.spells[result.name] == nil) {
                            self.spellList.append(result.name)
                            self.spells[result.name] = result
                        }
                    }
                case .failure(_):
                    NSLog("ERROR")
                }
                self.tableView.reloadData()
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        spells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)

        cell.textLabel?.text = spellList[indexPath.row]

        return cell
    }
}
