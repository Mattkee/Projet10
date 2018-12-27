//
//  SearchResultTableViewCell.swift
//  Reciplease
//
//  Created by Lei et Matthieu on 24/10/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//
import UIKit

class SearchResultTableViewCell: UITableViewCell {

    var link : RecipeListTableViewController?
    var isFavorite = false

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 20
        setupRating()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var ingredientList: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var addFavoriteButton: UIButton!
    @IBOutlet weak var favoriteActivityIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet var ratingStar: [UIImageView]!
    
    @IBAction func addRemoteFavorite(_ sender: UIButton) {
        favoriteActivityIndicator.color = .black
        favoriteActivityIndicator.isHidden = false
        favoriteActivityIndicator.startAnimating()
        addFavoriteButton.isHidden = true
        link?.addRemoveFavorite(self)
    }
    
    
    var searchRecipe : SearchRecipe.Matches! {
        didSet {
            self.recipeTitle.text = searchRecipe.recipeName
            let ingredients = searchRecipe.ingredients.joined(separator: ", ")
            self.ingredientList.text = ingredients
            
            let time = timeFormatted(totalSeconds: searchRecipe.totalTimeInSeconds)
            self.timeLabel.text = time
            let image = UIImage.recipeImage(searchRecipe.smallImageUrls[0])
            self.recipeImage.image = image
        }
    }

    private  func timeFormatted(totalSeconds: Int) -> String {
        //        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        let hours: Int = totalSeconds / 3600
        if hours == 0 {
            return String(format: "%02dmin", minutes)
        } else {
            return String(format: "%01dh %02dmin", hours, minutes)
        }
    }
    private func setupRating() {
        for _ in 0..<5 {
            let imageView = UIImageView()
            ratingStackView.addArrangedSubview(imageView)
            
            ratingStar.append(imageView)
        }
    }
}
