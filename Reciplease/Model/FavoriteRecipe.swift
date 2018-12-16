//
//  FavoriteRecipe.swift
//  Reciplease
//
//  Created by Lei et Matthieu on 14/12/2018.
//  Copyright © 2018 Mattkee. All rights reserved.
//

import Foundation
import CoreData

class FavoriteRecipe: NSManagedObject {
    static var all: [FavoriteRecipe] {
        let request: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        guard let recipe = try? AppDelegate.viewContext.fetch(request) else { return [] }
        return recipe
    }

    static func deleteAll() {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: FavoriteRecipe.fetchRequest())
        let _ = try? AppDelegate.viewContext.execute(deleteRequest)
    }

    static func save(_ name: String, _ id: String, _ totalTime: String, _ rating: String, _ ingredientList: [String], _ image : String) {
        let favoriteRecipe = FavoriteRecipe(context: AppDelegate.viewContext)
        favoriteRecipe.name = name
        favoriteRecipe.id = id
        favoriteRecipe.totalTime = totalTime
        favoriteRecipe.rating = rating
        favoriteRecipe.image = image
        
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
