//
//  TodoList+CoreDataProperties.swift
//  TodoLists
//
//  Created by НИКИТА ПЕСНЯК on 5.09.24.
//
//

import Foundation
import CoreData


extension TodoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoList> {
        return NSFetchRequest<TodoList>(entityName: "TodoList")
    }

    @NSManaged public var id: Int16
    @NSManaged public var todo: String?
    @NSManaged public var completed: Bool
    @NSManaged public var userId: Int16
    @NSManaged public var name: String?

}

extension TodoList : Identifiable {

}
