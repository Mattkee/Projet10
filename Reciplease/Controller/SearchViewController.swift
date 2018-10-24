//
//  SearchViewController.swift
//  Reciplease
//
//  Created by Lei et Matthieu on 24/10/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientTableView.dataSource = self
        ingredientTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    var ingredient = [String]()
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBAction func addButton(_ sender: UIButton) {
        guard let text = searchTextField.text else {
            return
        }
        ingredient.append(text)
        ingredientTableView.reloadData()
    }
    
    @IBAction func clearButton(_ sender: UIButton) {
        clear()
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
    }
    
    @IBOutlet weak var ingredientTableView: UITableView!
    
    func clear() {
        ingredient = [String]()
        ingredientTableView.reloadData()
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
extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredient.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Ingredient", for: indexPath)
        
        let nameIngredient = "- \(ingredient[indexPath.row])"
        cell.textLabel?.text = nameIngredient
        
        return cell
    }
}
