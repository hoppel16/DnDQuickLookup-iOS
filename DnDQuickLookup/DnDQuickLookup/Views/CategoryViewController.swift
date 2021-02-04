//
//  CategoryViewController.swift
//  DnDQuickLookup
//
//  Created by Hunter Oppel on 2/3/21.
//

import UIKit

class CategoryViewController: UIViewController {

    var networkAPI = Networking()

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!

    private var categories = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        fetchAllCategories()
    }

    private func fetchAllCategories() {
        networkAPI.fetchAllCategoriesFromAPI { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let decodedCategories):
                    self.convertJSONStringintoCategories(decodedCategories)
                case .failure(_):
                    print("ERROR")
                }
            }
        }
    }

    private func convertJSONStringintoCategories(_ jsonString: String) {
        let splitCategories = jsonString.split(separator: ",")
        for category in splitCategories {
            var seperatedCategory = String(category.split(separator: ":")[0])
            seperatedCategory = seperatedCategory.replacingOccurrences(of: ["{", "\\", "\"", ")"], with: "")
            seperatedCategory = seperatedCategory.replacingOccurrences(of: "-", with: " ")
            self.categories.append(seperatedCategory.capitalized)
        }
        self.tableView.reloadData()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let cell = tableView.cellForRow(at: indexPath),
                  let VC = segue.destination as? DetailViewController
                  else { return }

            VC.selectedCategory = cell.textLabel?.text
            VC.networkAPI = networkAPI
        }
    }
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
