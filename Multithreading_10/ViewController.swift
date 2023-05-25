//
//  ViewController.swift
//  Multithreading_10
//
//  Created by Дмитрий Гусев on 25.05.2023.
//

import UIKit

class ViewController: UIViewController {

    var dataTmp: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        image.center = view.center
        view.addSubview(image)
        let imageUrl = URL(string: "https://thumbs.dreamstime.com/z/grunge-green-accepted-word-square-rubber-seal-stamp-white-background-grunge-green-accepted-word-square-rubber-seal-stamp-139591946.jpg")
        
//        DispatchQueue.global(qos: .utility).async {
//
//            guard let data = try? Data(contentsOf: imageUrl!) else {
//                print("error")
//                return
//            }
//
//            DispatchQueue.main.async {
//                image.image = UIImage(data: data)
//            }
//
//        }
//        let queue = DispatchQueue(label: "MyQueue", attributes: .concurrent)
//        let work = DispatchWorkItem {
//            guard let data = try? Data(contentsOf: imageUrl!) else {
//                print("error")
//                return
//            }
//            self.dataTmp = data
//        }
//        work.notify(queue: .main) {
//            image.image = UIImage(data: self.dataTmp ?? Data())
//        }
//
//        queue.async(execute: work)
        var viewMine = UIView(frame: CGRect(x: 0, y: 0, width: 800, height: 800))
        var pictureView = UIImageView(frame: CGRect(x: 0, y: 0, width: 800, height: 800))
        pictureView.backgroundColor = .yellow
        pictureView.contentMode = .scaleAspectFit
        viewMine.addSubview(pictureView)
        
        view.addSubview(viewMine)
        
        //1 classic Method
        
        func fetchImage() {
            let queue = DispatchQueue.global(qos: .utility)
            queue.async {
                if let data = try? Data(contentsOf: imageUrl!) {
                    DispatchQueue.main.async {
                        pictureView.image = UIImage(data: data)
                    }
                }
            }
        }
        
//        fetchImage()
        
        //2 DispatchWorkItem
        
       func fetchImage2() {
           var data: Data?
           let queue = DispatchQueue.global(qos: .utility)
           
           let workItem = DispatchWorkItem {
               data = try? Data(contentsOf: imageUrl!)
               print(Thread.current)
           }
           queue.async(execute: workItem)
           
           workItem.notify(queue: .main) {
               if let imageData = data {
                   pictureView.image = UIImage(data: imageData)
               }
           }
        }
//        fetchImage2()
        
        //3 URLSession
        
        func fetchImage3() {

            let task = URLSession.shared.dataTask(with: imageUrl!) { data, response, error in
                print(Thread.current)
                if let imageData = data {
                    DispatchQueue.main.async {
                        pictureView.image = UIImage(data: imageData)
                    }
                }
            }
            task.resume()
         }
        fetchImage3()
    }


}

class DispatchWorkItem1 {
    private let queue = DispatchQueue(label: "DispatchWorkItem1", attributes: .concurrent)
    
    func create() {
        let workItem = DispatchWorkItem {
            
            print(Thread.current)
            print("Start task")
        }
        
        workItem.notify(queue: .main) {
            print(Thread.current)
            print("Task finish")
        }
        queue.async(execute: workItem)
    }
}


class DispatchWorkItem2 {
    private let queue = DispatchQueue(label: "DispatchWorkItem2")
    
    func create() {

        queue.async {
            print(Thread.current)
            sleep(1)
            print("Task 1")
        }
        queue.async {
            print(Thread.current)
            sleep(1)
            print("Task 2")
        }
        
        let workItem = DispatchWorkItem {
            print(Thread.current)
            print("Start work item task 3")
        }
        
        queue.async(execute: workItem)
        workItem.cancel()
    }
}
