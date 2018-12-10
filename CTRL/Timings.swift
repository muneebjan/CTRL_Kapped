//
//  Timings.swift
//  CTRL
//
//  Created by Ali Apple on 03/12/2018.
//  Copyright © 2018 Ali Apple. All rights reserved.
//

import Foundation
import RealmSwift

class Timings: Object{
    @objc dynamic var pickUpNumber: String = ""
    @objc dynamic var pickUpTime: String = ""
    @objc dynamic var dropDownTime: String = ""
}
