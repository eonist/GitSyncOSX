import Foundation
@testable import Utils
@testable import Element

class GraphZUtils {
    /**
     * New
     * Returns graph points (Basically the coordinates of where to place the visual graph points)
     * PARAM: spacing: the size of the items in the graph (aka vertical,horizontal spacing between dots)
     * PARAM: xProgress: progression of the graph.pos.x
     * PARAM: totCount: Tot count of all items in dp
     * PARAM: visibleCount: num of items currently visible to the user (may change when resizing win)
     * PARAM: itemAt: returns the value for PARAM: index
     * PARAM: maxValue: is the maximum value among all values in dp. (May change when the underlying model changes)
     */
    static func points(rect:CGRect, spacing:CGSize, xProgress:CGFloat, totContentWidth:CGFloat, totCount:Int, visibleCount:Int, itemAt:(Int) -> Int? ,maxValue:Int) -> (points:[CGPoint],vValues:[Int]){
        let idxRange:(start:Int,end:Int) = GraphZUtils.idxRange(x: xProgress, width: totContentWidth, itemWidth: spacing.w, totCount: totCount, visibleCount: visibleCount)
//        Swift.print("idxRange: " + "\(idxRange)")
        let vValues:[Int] = GraphZUtils.vValues(idxRange: idxRange, itemAt: itemAt)
//        Swift.print("vValues.count: " + "\(vValues.count)")
//        let maxValue:Int = maxValue != nil ? maxValue! : vValues.max() ?? {fatalError("err: \(vValues.count)")}()/*Finds the largest number in among vValues*/ //⚠️️ I think this should be done in the caller. or make a method for just the case where you dont pass maxValue
        let pts = points(idxRange:idxRange, vValues: vValues, maxValue: maxValue,rect:rect, spacing:spacing)
        return (points:pts, vValues:vValues)
    }
    /**
     * New
     */
    static func points(idxRange:(start:Int,end:Int), vValues:[Int], maxValue:Int, rect:CGRect, spacing:CGSize) -> [CGPoint]{
        let x:CGFloat = rect.x//spacing.width
        let y:CGFloat = rect.height - (rect.y)//the y point to start from, basically bottom
        let h:CGFloat = rect.height - (rect.y)//the height to work within
        //TODO: ⚠️️ use enumerated and get the vVal as well on the bellow line
        return vValues.indices.map{ (i:Int) in//i is relative index
            let p:CGPoint = {
                let value:CGFloat = vValues[i].cgFloat
                let ratio:CGFloat = value/maxValue.cgFloat/*a value between 0-1*/
                //ratio = ratio.isNaN ? 0 : ratio//cases can be
                //Swift.print("ratio: " + "\(ratio)")
                let dist:CGFloat = h*ratio
                let e:Int = idxRange.start + i//absolute index
                let x:CGFloat = x + (e * spacing.width)
                let y:CGFloat = y - dist
                let _y:CGFloat = y.isNaN ? rect.height - rect.y : y//⚠️️ quick fix, for when vValue is 0
                return CGPoint(x,_y)
            }()
            return p
        }
    }
    /**
     * Returns points for index range
     */
    static func vValues(idxRange:(start:Int,end:Int), itemAt:(Int)->Int?) -> [Int]{
        return (idxRange.start..<idxRange.end).indices.map{ (i:Int) in
            return itemAt(i) ?? 0//{fatalError("no point at:\(i) this index")}()
        }
    }
    /**
     * Returns indecies from x,width,itemWidth
     * PARAM: width is the totalWidth of the list
     * NOTE; We can also use modulo to get index: modulo;reminder = x %% itemWidth;x - remainderro
     */
    static func idxRange(x:CGFloat, width:CGFloat, itemWidth:CGFloat, totCount:Int, visibleCount:Int ) -> (start:Int,end:Int){
        let idx:Int = Utils.index(x: x, width: width, totCount: totCount)
        if abs(x) > itemWidth {
            let end:Int = abs(x) < (width - itemWidth) ? idx+visibleCount+1 : idx+visibleCount
            return (start:idx-1,end:end)
        }else {
            return (start:idx,end:idx+visibleCount+2)
        }
    }
    /**
     * New
     */
    static func minY(pts:[CGPoint]) -> CGFloat{
        let subSet:[CGPoint] = pts//pts.slice2(0, pts.count-1)
//        Swift.print("subSet.count: " + "\(subSet.count)")
        let minY:CGFloat = subSet.map{$0.y}.min() ?? {fatalError("err")}()
        return minY
    }
}
private class Utils{
    /**
     * Returns the absolute index of an item based on x
     */
    static func index(x:CGFloat, width:CGFloat,totCount:Int) -> Int{
        let scalar:CGFloat = (-x)/width/* we flip the x to be positive*/
        //            Swift.print("scalar: " + "\(scalar)")
        let index:Int = (scalar * totCount).int//goal is to get index
        return index
    }
    
}

