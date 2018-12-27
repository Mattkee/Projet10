//
//  RecipeListTableViewController.swift
//  Reciplease
//
//  Created by Lei et Matthieu on 13/11/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import UIKit

class RecipeListTableViewController: UITableViewController {

    let recipeService = RecipeService()
    var searchResult : SearchRecipe?
    var activityIndicator = false

    var displayAlertDelegate: DisplayAlert?

    @IBOutlet var recipeListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = true
        displayAlertDelegate = self
        searchRecipe()
    }

    override func viewWillAppear(_ animated: Bool) {
        recipeListTableView.reloadData()
    }

    private func searchRecipe() {
        recipeService.getSearchRecipe { (error, recipes) in
            guard error == nil else {
                guard let error = error else {
                    return
                }
                self.showAlert(title: Constant.titleAlert, message: error)
                return
            }
            self.searchResult = recipes
            self.activityIndicator = false
            self.recipeListTableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
            guard let recipes = searchResult?.matches else {
                return 0
            }
            return recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipe", for: indexPath) as? SearchResultTableViewCell else {
            return UITableViewCell()
        }
        cell.searchRecipe = searchResult?.matches[indexPath.row]
        guard let rating = searchResult?.matches[indexPath.row].rating else {
            return UITableViewCell()
        }
        ratingDisplay(String(rating), cell.ratingStar)
        
        var isFavorite : Bool {
            if let recipe = searchResult?.matches[indexPath.row] {
                let favorite = FavoriteRecipe.all.contains(where: { $0.id == recipe.id })
                return favorite
            } else {
                return false
            }
        }
        cell.link = self
        cell.isFavorite = isFavorite
        cell.addFavoriteButton.setImage(isFavorite ? #imageLiteral(resourceName: "favorite") : #imageLiteral(resourceName: "add-favorite"), for: .normal)
        cell.favoriteActivityIndicator.stopAnimating()
        cell.favoriteActivityIndicator.isHidden = true
        cell.addFavoriteButton.isHidden = false
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "footerCell") as? FooterTableViewCell else {
            return UITableViewCell()
        }
        cell.activityIndicator.startAnimating()
        cell.label.text = "wait upload..."
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return activityIndicator ? 200 : 0
    }
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier) {
            case "recipe":
                guard let recipeViewController = segue.destination as? RecipeViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                guard let selectedRecipeCell = sender as? SearchResultTableViewCell else {
                    fatalError("error envoi")
                }
                
                guard let indexPath = tableView.indexPath(for: selectedRecipeCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                guard let id = searchResult?.matches[indexPath.row].id else {
                    fatalError("no id")
                }
                guard let ingredients = searchResult?.matches[indexPath.row].ingredients else {
                    fatalError("no ingredients")
                }
                recipeViewController.recipeID = id
                recipeViewController.ingredients = ingredients
            
            default :
                print("error")
        }
    }
    func addRemoveFavorite(_ cell: UITableViewCell) {
        guard let indexPath = recipeListTableView.indexPath(for: cell) else {
            return
        }
        guard let recipeID = searchResult?.matches[indexPath.row].id else {
            return
        }
        if FavoriteRecipe.all.contains(where: {$0.id == recipeID}) {
            FavoriteRecipe.remove(recipeID)
            recipeListTableView.reloadRows(at: [indexPath], with: .fade)
        } else {
            recipeService.getRecipe(recipeID) { (error, recipe) in
                guard error == nil else {
                    guard let error = error else {
                        return
                    }
                    self.showAlert(title: Constant.titleAlert, message: error)
                    return
                }
                guard let listIngredient = self.searchResult?.matches[indexPath.row].ingredients.joined(separator: ", ") else {
                    return
                }
                guard let resultRecipe = recipe else {
                    return
                }
                FavoriteRecipe.save(resultRecipe, listIngredient)
                self.recipeListTableView.reloadRows(at: [indexPath], with: .fade)
            }
        }
    }
}

