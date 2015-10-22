import Foundation
import Cocoa
/*
 * Note: Apparently an NSTableViewDataSource must be in the tableview it self
 */
class TempTableView:NSTableView,NSTableViewDataSource,NSTableViewDelegate{
    //let monthNames:Array = ["March","April","May"]
    let data:[Dictionary<String,String>] = [["name":"John","age":"19"],["name":"Judith","age":"22"]]
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return data.count;
    }
    
    func tableView(tableView: NSTableView,objectValueForTableColumn tableColumn: NSTableColumn?,row: Int) -> AnyObject?{
        Swift.print((tableColumn?.title)! + " " + (tableColumn?.identifier)!)
        //Swift.print("fire a")
        
        return data[row][(tableColumn?.identifier)!]
    }
    
    /*
    This is for custom design i guess
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        Swift.print("fire b")
        // get the item for the row
        let item:Dictionary<String,String> = data[row]
        
        // get the NSTableCellView for the column
        let result : NSTableCellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView
        
        // set the string value of the text field in the NSTableCellView
        result.textField?.stringValue = item[tableColumn!.identifier]!//(tableColumn!.identifier) as! String
        
        // return the populated NSTableCellView
        return result
    }
    */
}