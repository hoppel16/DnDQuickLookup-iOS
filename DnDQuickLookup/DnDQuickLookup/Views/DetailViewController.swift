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
    var details: [String: CategoryResult] = [:]

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        if let selectedCategory = selectedCategory {
            fetchCategory(selectedCategory)
        }
        self.title = selectedCategory?.prettyPrint()
    }

    private func fetchCategory(_ category: String) {
        guard let networkAPI = networkAPI else { return }
        networkAPI.fetchCategoryFromAPI(category) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    for result in results.results {
                        if (self.details[result.name] == nil) {
                            self.details[result.name] = result
                        }
                    }
                case .failure(_):
                    NSLog("ERROR")
                }
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AdvancedDetailSegue" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let cell = tableView.cellForRow(at: indexPath),
                  let cellText = cell.textLabel?.text,
                  let VC = segue.destination as? AdvancedDetailViewController
                  else { return }

            VC.selectedCategory = self.selectedCategory
            VC.selectedDetail = self.details[cellText]
            VC.networkAPI = self.networkAPI
        }
    }

}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        details.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
        let detailList = Array(details.keys).sorted()
        cell.textLabel?.text = detailList[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
