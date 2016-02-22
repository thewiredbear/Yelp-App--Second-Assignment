//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    var businesses: [Business]!
    var searchBox:UISearchBar!
    var filteredData: [Business]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBox=UISearchBar()
        searchBox.sizeToFit()
        navigationItem.titleView=searchBox
        
        filteredData=businesses
        
        tableView.delegate=self
        tableView.dataSource=self
        
        searchBox.delegate=self
        
        tableView.rowHeight=UITableViewAutomaticDimension
        tableView.estimatedRowHeight=120

        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.filteredData=businesses
            self.tableView.reloadData()
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        })

/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredData != nil{
            return filteredData!.count
        }
        else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCellTableViewCell
        
        cell.business=filteredData[indexPath.row]
        
        return cell
    }
    
//    func searchBox(searchBar: UISearchBar, textDidChange searchText: String) {
//        filteredData = searchText.isEmpty ?  businesses: businesses.filter({(dataString: String) -> Bool in
//            return dataString.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
//        })
//        
//    }
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(searchBox: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        if searchText.isEmpty {
            filteredData = businesses
        } else {
            // The user has entered text into the search box
            // Use the filter method to iterate over all items in the data array
            // For each item, return true if the item should be included and false if the
            // item should NOT be included
            filteredData = businesses.filter({(dataItem: Business) -> Bool in
                // If dataItem matches the searchText, return true to include it
                if dataItem.name!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                    return true
                } else {
                    return false
                }
            })
        }
        for bus in filteredData{
            print(bus.name)
        }
        self.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBox: UISearchBar) {
        self.searchBox.showsCancelButton = true
        
    }
    
    func searchBarCancelButtonClicked(searchBox: UISearchBar) {
        searchBox.showsCancelButton = false
        searchBox.text = ""
        searchBox.resignFirstResponder()
        filteredData=businesses
        self.tableView.reloadData()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
