import Cocoa
@testable import Utils
@testable import Element


class TimeBarZ:ElasticScrollerFastList5{
    let graphZ:GraphZ
    override var dp:DataProvider {get{return graphZ.dp}set{_ = newValue}}
    private var graphScrollerHandler:TimeBarZHandler {return handler as! TimeBarZHandler}//move this to extension somewhere
    override lazy var handler:ProgressHandler = TimeBarZHandler(progressable:self)
    override lazy var moverGroup:MoverGroup = {return createMoverGroup()}()

    init(graphZ:GraphZ, size:CGSize = CGSize(), id:String? = nil) {
        self.graphZ = graphZ
        let listConfig = List5.Config.init(itemSize: CGSize(GraphZ.config.itemSize.w,GraphZ.config.topMargin), dp: DP.init(), dir: .hor)//the dp doesnt do anything
        super.init(config: listConfig, size: size, id: id)
    }
    override func scrollWheel(with event: NSEvent) {
        //override to block
//        super.scrollWheel(with: event)
    }
    required init(coder:NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    override func reUse(_ listItem: FastListItem) {
//        Swift.print("reUse listItem.idx: \(listItem.idx)")
//        super.reUse(listItem)
//        if let dpItem = dp.item(idx), let title:String = dpItem["title"]{
//            Swift.print("title: " + "\(title)")
//        }
//    }
    //timeLabels
    override func resolveSkin() {
        super.resolveSkin()
        //createTimeLables()
    }
    func setProgressVal(_ value: CGFloat, _ dir: Dir) {
        guard dir == .hor else {return}//this makes the scrolling go in only the x-axis
        super.setProgressVal(value, dir)
    }
    override func getClassType() -> String {
        return "TimeBar"
    }
}
extension TimeBarZ{
    /**
     *
     */
    func createMoverGroup()->MoverGroup{
        Swift.print("TimeBarZ.createMoverGroup() self.contentSize:\(self.contentSize)")
        var group = MoverGroup(setProgressVal, self.maskSize, self.contentSize)
        group.event = (self as EventSendable).onEvent/*Add an eventHandler for the mover object, , this has no functionality in this class, but may have in classes that extends this class, like hide progress-indicator when all animation has stopped*/
        return group
    }
}
