//
//  Debounce.swift
//  flicker
//
//  Created by Georgy Solovei on 15.11.21.
//

import Foundation

struct Debounce<T: Equatable> {
    static func input(_ input: T,
                      interval: TimeInterval = 0.6,
                      comparedAgainst current: @escaping @autoclosure () -> (T),
                      perform: @escaping (T) -> ()) {

        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            if input == current() { perform(input) }
        }
    }
}
