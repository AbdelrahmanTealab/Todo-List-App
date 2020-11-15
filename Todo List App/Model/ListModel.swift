//
//  ListModel.swift
//  Todo List App
//
//  Created by Abdelrahman  Tealab on 2020-11-13.
//  Student ID: 301164103

import Foundation
// this is the data structure of a list object
struct List {
    var title:String?
    var dueDate:Date?
    var items:Array<String?>? //this is assuming that i will be able to add items into the list aside from notes
}

