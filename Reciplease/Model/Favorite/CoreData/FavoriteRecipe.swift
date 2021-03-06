//
//  FavoriteRecipe.swift
//  Reciplease
//
//  Created by Lei et Matthieu on 14/12/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import Foundation
import CoreData

//CoreData Object
class FavoriteRecipe: NSManagedObject {
    //FavoriteRecipes stored in coreData object.
    static var all: [FavoriteRecipe] {
        let request: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        guard let recipe = try? AppDelegate.viewContext.fetch(request) else { return [] }
        return recipe
    }

    //this method deletes all data for object.
    static func deleteAll() {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: FavoriteRecipe.fetchRequest())
        let _ = try? AppDelegate.viewContext.execute(deleteRequest)
    }

    //this method allow to recover data contains name.
    static func fetch(_ name: String) -> [FavoriteRecipe] {
        let request: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", name)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        guard let recipe = try? AppDelegate.viewContext.fetch(request) else { return [] }
        return recipe
    }
    //this method allow to save data in coreData object
    static func save(_ recipe: Recipe, _ ingredientsDetail: String) {
        let favoriteRecipe = FavoriteRecipe(context: AppDelegate.viewContext)
        favoriteRecipe.name = recipe.name
        favoriteRecipe.id = recipe.id
        favoriteRecipe.totalTime = recipe.totalTime
        favoriteRecipe.rating = String(recipe.rating)
        favoriteRecipe.image = recipe.images[0].hostedSmallUrl
        favoriteRecipe.sourceUrl = recipe.source.sourceRecipeUrl
        favoriteRecipe.ingredientsDetail = ingredientsDetail
        let ingredientList = recipe.ingredientLines
        
        ingredientList.forEach { element in
            let ingredient = Ingredient(context: AppDelegate.viewContext)
            ingredient.name = element
            ingredient.recipe = favoriteRecipe
        }

        do {
            try AppDelegate.viewContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    //this method allow to remove data in coreData object
    static func remove(_ id: String) {
        let request: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        do {
            let object = try AppDelegate.viewContext.fetch(request)
            if !object.isEmpty {
                AppDelegate.viewContext.delete(object[0])
                try? AppDelegate.viewContext.save()
            }
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
