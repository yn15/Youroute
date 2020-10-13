//
//  StoryController.swift
//  Gallery
//
//  Created by CY on 2020/05/14.
//  Copyright © 2020 CY. All rights reserved.
//

import UIKit
import Vision
import Foundation
import AVFoundation
import CoreMedia
import VideoToolbox
import Firebase
import FirebaseUI
import FirebaseStorage
import FirebaseFirestoreSwift

class StoryController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var label1: UILabel!
    
    var images : [String] = []
    let fireref = Firestore.firestore()
    let storage = Storage.storage()
    
    let yolo = YOLO()
    var labelArray = Set<String>();
    var tag = ""
    var videoCapture: VideoCapture!
    
    var labeltext = ""

    var boundingBoxes = [BoundingBox]()
    var colors: [UIColor] = []

    let ciContext = CIContext()
    var resizedPixelBuffer: CVPixelBuffer?

    let semaphore = DispatchSemaphore(value: 2)
    
    
    
    var rcvimage: UIImage?
    
    //var images = [ "image1.jpg", "image2.jpeg" , "image3.jpeg", "image4.jpeg" ]
    
    //main images
    
    @IBOutlet weak var Main_Images: UIImageView!
    @IBOutlet weak var Text_View: UITextView!
    
    @IBOutlet weak var checkCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        predict()
               super.viewDidLoad()
               setUpBoundingBoxes()
               setUpCoreImage()
               predict(image: rcvimage!);
        
        Main_Images.image = rcvimage
        print(label.text)
    }
    
    func predict() {
        guard let image = rcvimage,
            let pixelBuffer: CVPixelBuffer = image.pixelBuffer(width: Int(image.size.width),height: Int(image.size.height))
            else { return }
        
        // create model
        let model = ImageClassifier()
        
        // predict
        if let result = try? model.prediction(image: pixelBuffer) {
            let predictedLabel = result.classLabel
            let confidence = result.classLabelProbs[result.classLabel] ?? 0.0
            label.text = "\(predictedLabel)"//" , 정확도 \(round(confidence*1000)/10)%"
        }
    }
    
    func setUpBoundingBoxes() {
        for _ in 0..<YOLO.maxBoundingBoxes {
          boundingBoxes.append(BoundingBox())
        }

        // Make colors for the bounding boxes. There is one color for each class,
        // 80 classes in total.
        for r: CGFloat in [0.2, 0.4, 0.6, 0.8, 1.0] {
          for g: CGFloat in [0.3, 0.7, 0.6, 0.8] {
            for b: CGFloat in [0.4, 0.8, 0.6, 1.0] {
              let color = UIColor(red: r, green: g, blue: b, alpha: 1)
              colors.append(color)
            }
          }
        }
      }

      func setUpCoreImage() {
        let status = CVPixelBufferCreate(nil, YOLO.inputWidth, YOLO.inputHeight,
                                         kCVPixelFormatType_32BGRA, nil,
                                         &resizedPixelBuffer)
        if status != kCVReturnSuccess {
          print("Error: could not create resized pixel buffer", status)
        }
      }


      //  UI stuff

      override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
      }


      // MARK: - Doing inference
      func predict(image: UIImage) {
        if let pixelBuffer = image.pixelBuffer(width: YOLO.inputWidth, height: YOLO.inputHeight) {
          predict(pixelBuffer: pixelBuffer)
        }
        
      }

      func predict(pixelBuffer: CVPixelBuffer) {
        // Measure how long it takes to predict a single video frame.
    //    let startTime = CACurrentMediaTime()

        // Resize the input with Core Image to 416x416.
        guard let resizedPixelBuffer = resizedPixelBuffer else { return }
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let sx = CGFloat(YOLO.inputWidth) / CGFloat(CVPixelBufferGetWidth(pixelBuffer))
        let sy = CGFloat(YOLO.inputHeight) / CGFloat(CVPixelBufferGetHeight(pixelBuffer))
        let scaleTransform = CGAffineTransform(scaleX: sx, y: sy)
        let scaledImage = ciImage.transformed(by: scaleTransform)
        ciContext.render(scaledImage, to: resizedPixelBuffer)

        // This is an alternative way to resize the image (using vImage):
        //if let resizedPixelBuffer = resizePixelBuffer(pixelBuffer,
        //                                              width: YOLO.inputWidth,
        //                                              height: YOLO.inputHeight)

        // Resize the input to 416x416 and give it to our model.
        if let boundingBoxes = try? yolo.predict(image: resizedPixelBuffer) {

          showOnMainThread(boundingBoxes) //, elapsed)
            
        }
      }

        func showOnMainThread(_ boundingBoxes: [YOLO.Prediction]) {
        DispatchQueue.main.async {
          // For debugging, to make sure the resized CVPixelBuffer is correct.
          //var debugImage: CGImage?
          //VTCreateCGImageFromCVPixelBuffer(resizedPixelBuffer, nil, &debugImage)
          //self.debugImageView.image = UIImage(cgImage: debugImage!)

          self.show(predictions: boundingBoxes)

          self.semaphore.signal()
        }
      }

      func show(predictions: [YOLO.Prediction]) {
        // --SGH close if there is detection shut the frame buffer

        for i in 0..<boundingBoxes.count {
          if i < predictions.count {
            let prediction = predictions[i]

            // The predicted bounding box is in the coordinate space of the input
            // image, which is a square image of 416x416 pixels. We want to show it
            // on the video preview, which is as wide as the screen and has a 4:3
            // aspect ratio. The video preview also may be letterboxed at the top
            // and bottom.
            let width = view.bounds.width
            let height = width * 4 / 3
            let scaleX = width / CGFloat(YOLO.inputWidth)
            let scaleY = height / CGFloat(YOLO.inputHeight)
            let top = (view.bounds.height - height) / 2

            // Translate and scale the rectangle to our own coordinate system.
            var rect = prediction.rect
            rect.origin.x *= scaleX
            rect.origin.y *= scaleY
            rect.origin.y += top
            rect.size.width *= scaleX
            rect.size.height *= scaleY

            // Show the bounding box.
            //let label = String(format: "%@ %.1f", labels[prediction.classIndex], prediction.score * 100)
            let label = String(format:labels[prediction.classIndex])
            //tag = tag + " #" + label
            labelArray.insert(label)
            //let color = colors[prediction.classIndex]
            
            //boundingBoxes[i].show(frame: rect, label: label, color: color)
          } else {
            boundingBoxes[i].hide()
          }
        }
        for t in labelArray {
            tag = tag + "#" + t + " "
        }
        //print(labelArray)
        label1.text = "\(tag)"
      }
    
    func test() {
        fireref.collection(labeltext).document(labeltext).addSnapshotListener { (documentSnapshot, error) in
            guard let document = documentSnapshot else {
                print("error")
                return
            }
            //var Ary : Array = []
            let Ary = (document.get("Picture") as! Array<Any>)
            //self.images.append(document.get("cc") as! String)
            //print(self.images)
            for Arys in Ary {
                self.images.append(Arys as! String)
                //print(Arys)
            }
            //print(Ary)
            print("11")
            print(self.images)
            self.checkCollectionView.reloadData()
        }
    }
    
    
}

extension StoryController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //let images = [ "test.jpeg", "test2.jpeg" , "test3.jpeg", "test4.jpeg" ]
        
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        Main_Images.image = UIImage(named: images[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 126, height: 152)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = checkCollectionView.dequeueReusableCell(withReuseIdentifier: "check", for: indexPath) as? StorySubCell
        
//        self.storage.reference(forURL: images[indexPath.row]).downloadURL { (url, error) in
//                                let data = NSData(contentsOf: url!)
//                                let image = UIImage(data: data! as Data)
//                                cell?.SubImage.image = image
//                                }
        //                    }
        
        cell?.SubImage.image = UIImage(named: images[indexPath.row])
        
        return cell!
    }
    
    
    
}


