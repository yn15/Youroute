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
    
    var labeltext : String = ""

    var boundingBoxes = [BoundingBox]()
    var colors: [UIColor] = []

    let ciContext = CIContext()
    var resizedPixelBuffer: CVPixelBuffer?

    let semaphore = DispatchSemaphore(value: 2)
    
    
    
    var rcvimage: UIImage?
    
    @IBOutlet weak var Main_Images: UIImageView!
    @IBOutlet weak var Text_View: UITextView!
    
    @IBOutlet weak var checkCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        predict()
               super.viewDidLoad()
               setUpBoundingBoxes()
               setUpCoreImage()
               predict(image: rcvimage!);
        
        Main_Images.image = rcvimage
        
    }
    
    func predict() {
        guard let image = rcvimage,
            let pixelBuffer: CVPixelBuffer = image.pixelBuffer(width: Int(image.size.width),height: Int(image.size.height))
            else { return }
        
        let model = ImageClassifier()
        
        if let result = try? model.prediction(image: pixelBuffer) {
            let predictedLabel = result.classLabel
            label.text = "\(predictedLabel)"
            //test(labeltexta: predictedLabel)
            var ttag = ""
            
            switch predictedLabel {
                case "감은사지":
                    ttag = "감은사지"
                case "경주타워":
                    ttag = "경주타워"
                case "불국사":
                    ttag = "불국사"
                default:
                    ttag = ""
            }

            
            fireref.collection(ttag).document(ttag).addSnapshotListener { (documentSnapshot, error) in
                guard let document = documentSnapshot else {
                    print("error")
                    return
                }
                print(document.documentID)
                let Ary = (document.get("Picture") as! Array<Any>)
                for Arys in Ary {
                    self.images.append(Arys as! String)
                }
                self.checkCollectionView.reloadData()
            }
        }
        
        
    }
    
//    func test(labeltexta: String) {
//        print(labeltexta)
//        let a = labeltexta
//        fireref.collection(a).document(a).addSnapshotListener { (documentSnapshot, error) in
//            guard let document = documentSnapshot else {
//                print("error")
//                return
//            }
//
//            let Ary = (document.get("Picture") as! Array<Any>)
//            for Arys in Ary {
//                self.images.append(Arys as! String)
//            }
//            self.checkCollectionView.reloadData()
//        }
  // }
    
    func setUpBoundingBoxes() {
        for _ in 0..<YOLO.maxBoundingBoxes {
          boundingBoxes.append(BoundingBox())
        }

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

      override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
      }

      func predict(image: UIImage) {
        if let pixelBuffer = image.pixelBuffer(width: YOLO.inputWidth, height: YOLO.inputHeight) {
          predict(pixelBuffer: pixelBuffer)
        }
        
      }

      func predict(pixelBuffer: CVPixelBuffer) {
        
        guard let resizedPixelBuffer = resizedPixelBuffer else { return }
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let sx = CGFloat(YOLO.inputWidth) / CGFloat(CVPixelBufferGetWidth(pixelBuffer))
        let sy = CGFloat(YOLO.inputHeight) / CGFloat(CVPixelBufferGetHeight(pixelBuffer))
        let scaleTransform = CGAffineTransform(scaleX: sx, y: sy)
        let scaledImage = ciImage.transformed(by: scaleTransform)
        ciContext.render(scaledImage, to: resizedPixelBuffer)

        if let boundingBoxes = try? yolo.predict(image: resizedPixelBuffer) {

          showOnMainThread(boundingBoxes) //, elapsed)
            
        }
      }

        func showOnMainThread(_ boundingBoxes: [YOLO.Prediction]) {
        DispatchQueue.main.async {
            
          self.show(predictions: boundingBoxes)

          self.semaphore.signal()
        }
      }

      func show(predictions: [YOLO.Prediction]) {

        for i in 0..<boundingBoxes.count {
          if i < predictions.count {
            let prediction = predictions[i]

            let width = view.bounds.width
            let height = width * 4 / 3
            let scaleX = width / CGFloat(YOLO.inputWidth)
            let scaleY = height / CGFloat(YOLO.inputHeight)
            let top = (view.bounds.height - height) / 2

            var rect = prediction.rect
            rect.origin.x *= scaleX
            rect.origin.y *= scaleY
            rect.origin.y += top
            rect.size.width *= scaleX
            rect.size.height *= scaleY

            let label = String(format:labels[prediction.classIndex])

            labelArray.insert(label)

          } else {
            boundingBoxes[i].hide()
          }
        }
        for t in labelArray {
            tag = tag + "#" + t + " "
        }
        label1.text = "\(tag)"
      }
    

    
}

extension StoryController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
            self.storage.reference(forURL: images[indexPath.row]).downloadURL { (url, error) in
                    let data = NSData(contentsOf: url!)
                    let image = UIImage(data: data! as Data)
                self.Main_Images.image = image
                }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 126, height: 152)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = checkCollectionView.dequeueReusableCell(withReuseIdentifier: "check", for: indexPath) as? StorySubCell
        print(images[indexPath.row])
        self.storage.reference(forURL: images[indexPath.row]).downloadURL { (url, error) in
                let data = NSData(contentsOf: url!)
                let image = UIImage(data: data! as Data)
                cell?.SubImage.image = image
                }
        
        return cell!
    }
    
}


