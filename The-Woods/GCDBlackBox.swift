//
//  GCDBlackBox.swift
//  The-Woods
//
//  Created by Udumala, Mary on 3/26/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
