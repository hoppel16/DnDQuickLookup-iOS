//
//  AdvancedDetailViewController.swift
//  DnDQuickLookup
//
//  Created by Hunter Oppel on 2/4/21.
//

import UIKit

class AdvancedDetailViewController: UIViewController {

    @IBOutlet var detailDescription: UITextView!

    var selectedCategory: String?
    var selectedDetail: CategoryResult?
    var networkAPI: Networking?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = selectedDetail?.name
        fetchDetail()
    }

    private func fetchDetail() {
        guard let selectedCategory = selectedCategory,
              let selectedDetail = selectedDetail,
              let networkAPI = networkAPI
              else { return }
        
        networkAPI.fetchDetailFromAPI(categoryName: selectedCategory, detailName: selectedDetail.index, completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let detailModel):
                    self.detailDescription.text = detailModel.desc?.joined(separator: "\n\n")
                case .failure(_):
                    NSLog("Failure")
                }
            }
        })
    }
}
