//
//  ViewController.swift
//  MultiThreadHomeWork
//
//  Created by Alexey Golovin on 19.02.2021.
//
/*

 Разберитесь в коде, указанном в данном примере.
 Вам нужно определить где конкретно реализованы проблемы многопоточности (Race Condition, Deadlock) и укажите их. Объясните, из-за чего возникли проблемы.
 Попробуйте устранить эти проблемы.
 Готовый проект отправьте на проверку. 
 
*/

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        exampleOne()
//        exampleTwo()
    
    }
    
    //проблема в асинхронности. Мы пытаемся присвоить значение элементу, которого ещё не существует, так как между добавлением элементов
    //проходит 1 секунда, присвоение же происходит мгновенно. Селаем задачи синхронными и через 1001 секунду получаем готовый необходимый
    //массив
    //Race Condition
    func exampleOne() {
        var storage: [String] = []
        let concurrentQueue = DispatchQueue(label: "concurrent", attributes: .concurrent)
        
        concurrentQueue.sync {
            for i in 0...1000 {
                sleep(1)
                storage.append("Cell: \(i)")
            }
        }

        concurrentQueue.sync {
            for i in 0...1000 {
                storage[i] = "Box: \(i)"
            }
        }
    }
    
    //Проблема с сихронном запуске задачи в главной очереди (в UI-потоке). При изменении на асинхронный запуск получаем последовательность
    //a -> d -> c -> b
    //Deathlock
    func exampleTwo() {
        print("a")
        DispatchQueue.main.async {
            DispatchQueue.main.async {
                print("b")
            }
            print("c")
        }
        print("d")
    }
}

