//
//  ViewController.swift
//  GCDsample
//
//  Created by eduardo fulgencio on 04/01/2020.
//  Copyright © 2020 Eduardo Fulgencio Comendeiro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var someBoolean = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        makeDispach_printBeforeChange()
        makeDispach_printWaintingChange()
        testEnterLeaveNotify()
    }
    
    func makeDispach_printBeforeChange() {
        someBoolean = false
        DispatchQueue(label: "MutateSomeBoolean").async {
            // perform some work here
            for _ in 0..<100 {
                    continue
            }
            self.someBoolean = true
        }
        // imprime si esperar el cambio a true
        print(someBoolean)

   }
    
    func makeDispach_printWaintingChange() {
        // imprimirá cuando el callback clousure ha finalizado
        executeSlowOperation { result in
            DispatchQueue.main.async {
                self.someBoolean = result
                print(self.someBoolean)
            }
        }
    }

    func executeSlowOperation(withCallback callback: @escaping (Bool) -> Void) {
        DispatchQueue(label: "MutateSomeBoolean").async {
            // perform some work here
            for _ in 0..<100 {
                continue
            }
            callback(true)
        }
    }
    
    // Se puede llamar a enter() en un dispatch group
    // enter() -> indica que una tarea en dispatch group no ha finilizado
    // leave() -> indica que la tarea ha finalizado
    // notify(queue:) -> ejecuta el completion handler

    func testEnterLeaveNotify() {
        executeAndWaitToLeave { result in
               DispatchQueue.main.async {
                   print(result)
               }
           }
    }
    
    func executeAndWaitToLeave(withCallback callback: @escaping (Bool) -> Void) {
        
        let queue = DispatchQueue(label: "movieDBQueue")
        let group = DispatchGroup()
        var estado = false
        queue.async(group: group) {
            group.enter()
            
            for i in 0..<1000 {
                if i == 800 {
                    estado = true
                }
            }
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) {
            callback(estado)
        }
     }
    
    
}

