//
//  ModelManager.swift
//  SQLiteExample
//
//  Created by Luis Javier Canto Hurtado on 14/04/21.
//

import Foundation

let sharedInstance = ModelManager()

class ModelManager: NSObject{
    
    var database: FMDatabase?
    
    class var instance: ModelManager{
        let documentsFolder = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let path = documentsFolder.appending("Movies.sqlite")
        sharedInstance.database = FMDatabase(path: path)
        return sharedInstance
    }
    
    func createDatabase() -> Bool{
        sharedInstance.database!.open()
        //let query = "CREATE TABLE IF NOT EXISTS movie(movieid INTEGER PRIMARY KEY, name TEXT, review INTEGER)"
        let query = "CREATE TABLE IF NOT EXISTS movie(movieid INTEGER PRIMARY KEY, name TEXT, review INTEGER, image TEXT)"
        let isCreated = sharedInstance.database!.executeUpdate(query, withArgumentsIn:[Any]())
        sharedInstance.database!.close()
        return isCreated
    }
    
    func addMovie(name: String, review: Int,image: String) -> Bool {
            sharedInstance.database!.open()
            //let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO movie (name, review) VALUES(?, ?)", withArgumentsIn: [name, review])
            let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO movie (name, review, image) VALUES(?, ?, ?)", withArgumentsIn: [name, review, image])
            sharedInstance.database!.close()
            return isInserted
        }
    
    func findMovie(name:String) -> Movie {
            let mov = Movie()
            sharedInstance.database!.open()
            let resultSet = sharedInstance.database!.executeQuery("SELECT * FROM movie WHERE name=?", withArgumentsIn: [name])
            if resultSet != nil && (resultSet?.next())! {
                mov.id = Int((resultSet?.int(forColumn: "movieId"))!)
                mov.name = name
                mov.review = Int((resultSet?.int(forColumn: "review"))!)
                mov.image = (resultSet?.string(forColumn: "image")!)!
            }
            sharedInstance.database!.close()
            return mov
        }
    
    func deleteMovie(name: String) -> Bool {
            sharedInstance.database!.open()
            let isDeleted = sharedInstance.database!.executeUpdate("DELETE FROM movie WHERE name=?", withArgumentsIn: [name])
            sharedInstance.database!.close()
            return isDeleted
        }
    
}


