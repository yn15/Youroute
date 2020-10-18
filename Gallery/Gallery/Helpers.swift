import Foundation
import UIKit
import CoreML
import Accelerate

let labels = [
    "사람", "자전거", "자동차", "오토바이", "비행기", "버스", "기차", "트럭", "보트", "신호등",
    "소화전", "정지신호", "주차권 판매기", "벤치", "새", "고양이", "강아지", "말", "양", "소",
    "코끼리", "곰", "얼룩말", "기린", "배낭", "우산", "핸드백", "넥타이", "여행가방", "프리스비",
    "스키", "스노우 보드", "운동용 공", "연", "야구 방망이", "야구 글러브", "스케이트 보드", "서핑 보드", "테니스 라켓", "병",
    "와인잔", "컵", "포크", "칼", "수저", "그릇", "바나나", "사과", "샌드위치", "오랜지",
    "브로콜리", "당근", "핫도그", "피자", "도넛", "케이크", "의자", "소파", "화분", "침대",
    "식탁", "화장실", "TV", "노트북", "마우스", "리모컨", "키보드", "휴대폰", "전자레인지", "오븐",
    "토스트기", "싱크대", "냉장고", "책", "시계", "꽃병", "가위", "곰 인형", "헤어 드라이기", "칫솔"
]

let anchors: [[Float]] = [[116,90,  156,198,  373,326], [30,61,  62,45,  59,119], [10,13,  16,30,  33,23]]

func nonMaxSuppression(boxes: [YOLO.Prediction], limit: Int, threshold: Float) -> [YOLO.Prediction] {

  
  let sortedIndices = boxes.indices.sorted { boxes[$0].score > boxes[$1].score }

  var selected: [YOLO.Prediction] = []
  var active = [Bool](repeating: true, count: boxes.count)
  var numActive = active.count

  outer: for i in 0..<boxes.count {
    if active[i] {
      let boxA = boxes[sortedIndices[i]]
      selected.append(boxA)
      if selected.count >= limit { break }

      for j in i+1..<boxes.count {
        if active[j] {
          let boxB = boxes[sortedIndices[j]]
          if IOU(a: boxA.rect, b: boxB.rect) > threshold {
            active[j] = false
            numActive -= 1
            if numActive <= 0 { break outer }
          }
        }
      }
    }
  }
  return selected
}

public func IOU(a: CGRect, b: CGRect) -> Float {
  let areaA = a.width * a.height
  if areaA <= 0 { return 0 }

  let areaB = b.width * b.height
  if areaB <= 0 { return 0 }

  let intersectionMinX = max(a.minX, b.minX)
  let intersectionMinY = max(a.minY, b.minY)
  let intersectionMaxX = min(a.maxX, b.maxX)
  let intersectionMaxY = min(a.maxY, b.maxY)
  let intersectionArea = max(intersectionMaxY - intersectionMinY, 0) *
                         max(intersectionMaxX - intersectionMinX, 0)
  return Float(intersectionArea / (areaA + areaB - intersectionArea))
}

extension Array where Element: Comparable {
    
  public func argmax() -> (Int, Element) {
    precondition(self.count > 0)
    var maxIndex = 0
    var maxValue = self[0]
    for i in 1..<self.count {
      if self[i] > maxValue {
        maxValue = self[i]
        maxIndex = i
      }
    }
    return (maxIndex, maxValue)
  }
}


public func sigmoid(_ x: Float) -> Float {
  return 1 / (1 + exp(-x))
}

public func softmax(_ x: [Float]) -> [Float] {
  var x = x
  let len = vDSP_Length(x.count)

  
  var max: Float = 0
  vDSP_maxv(x, 1, &max, len)

  max = -max
  vDSP_vsadd(x, 1, &max, &x, 1, len)

  var count = Int32(x.count)
  vvexpf(&x, x, &count)

  var sum: Float = 0
  vDSP_sve(x, 1, &sum, len)

  vDSP_vsdiv(x, 1, &sum, &x, 1, len)

  return x
}
