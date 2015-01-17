//
//  NetworkHelper.swift
//  WhoisInSpace
//
//  Created by David on 12/30/14.
//  Copyright (c) 2014 David Fry. All rights reserved.
//

import Foundation
import UIKit

class NetworkHelper
{
    
    
    class func downloadJSONData(baseURL: String, endPoint: String, completionHandler:(jsonData:NSDictionary) ->(Void))
    {
        // Building the api url
        let baseURL = NSURL(string: baseURL)
        let endPointString = endPoint
        let fullApiURL = NSURL(string: endPointString, relativeToURL: baseURL)
        
        // Getting the Session and Task setup
        let session = NSURLSession.sharedSession()
        
        let task = session.downloadTaskWithURL(fullApiURL!, completionHandler: { (location, response, error) -> Void in
            if error == nil
            {
                
                let dataObject = NSData(contentsOfURL: location)
                let jsonDictionary = NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as NSDictionary
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(jsonData: jsonDictionary)
                    //tableView.reloadData()
                })
                
            }
        })
        
        task.resume()
    }
    
    class func getNewsFromRssFeed(url:String) -> [NewsItem]
    {
        var error:NSError?
        
        var xmlURL = NSURL(string: url)
        var xmlData = NSData(contentsOfURL: xmlURL!)
        
        var newsItems = [NewsItem]()
        
        if let xmlDoc = AEXMLDocument(xmlData: xmlData!, error: &error)
        {
            for item in xmlDoc.rootElement["channel"]["item"].all
            {
                var newNewsItem = NewsItem(title: item["title"].value, link: item["link"].value, description: item["description"].value)
                newsItems.append(newNewsItem)
            }
        }
        return newsItems
    }
    
    

}














