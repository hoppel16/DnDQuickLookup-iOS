//
//  MainTableViewController.swift
//  DnDQuickLookup
//
//  Created by Hunter Oppel on 2/2/21.
//

import UIKit

class MainTableViewController: UITableViewController {

    let networkAPI = Networking()
    let test = ["acid-arrow", "polymorph", "chill-touch", "magic-missile"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return test.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as? MainTableViewCell else { fatalError() }
        if cell.mainString.text?.isEmpty ?? true && !cell.activityIndicator.isAnimating {
            cell.activityIndicator.startAnimating()
            networkAPI.fetchSpellFromAPI(spellName: test[indexPath.row]) { result in
                NSLog("Beggining Fetch")
                DispatchQueue.main.async {
                    switch result {
                    case .success(let decodedSpell):
                        NSLog("Fetched \(decodedSpell.name)")
                        cell.mainString.text = decodedSpell.name
                        self.tableView.reloadData()
                        cell.activityIndicator.stopAnimating()
                    case .failure(_):
                        cell.mainString.text = "ERROR"
                        cell.activityIndicator.stopAnimating()
                    }
                }
            }
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
