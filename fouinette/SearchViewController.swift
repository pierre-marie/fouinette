//
//  ViewController.swift
//  fouinette
//
//  Created by pierre-marie de jaureguiberry on 12/7/17.
//  Copyright © 2017 vo2. All rights reserved.
//

import Cocoa
import Accounts

class SearchViewController: NSViewController {

    @IBOutlet weak var searchField: NSSearchField!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLinkedIn()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    // MARK: Search
    
    func search(name: String!) {
        
        NSLog("Start searching for : %@", name)
        
//        Alamofire.request("https://httpbin.org/get").responseJSON { response in
//            print("Request: \(String(describing: response.request))")   // original url request
//            print("Response: \(String(describing: response.response))") // http url response
//            print("Result: \(response.result)")                         // response serialization result
//
//            if let json = response.result.value {
//                print("JSON: \(json)") // serialized json response
//            }
//
//            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)") // original server data as UTF8 string
//            }
//        }
    }
    
    @IBAction func openMenu(_ sender: Any) {
        performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "menuSeg"), sender: self)
    }
    
    // MARK: NSSearchField delegates
    
    override func controlTextDidEndEditing(_ obj: Notification) {
        let textMov = obj.userInfo!["NSTextMovement"] as! NSNumber
        if (textMov.intValue == NSReturnTextMovement) { // User pressed the Enter key
            search(name: searchField.stringValue)
        }
    }
    
    // MARK: Internet accounts
    
    func loadLinkedIn() {
        
        /*
         // Options dictionary keys for LinkedIn access, for use with [ACAccountStore requestAccessToAccountsWithType:options:completion:]
         ACCOUNTS_EXTERN NSString * const ACLinkedInAppIdKey NS_DEPRECATED(10_9, 10_13, NA, NA, "Use LinkedIn SDK instead");           // Your LinkedIn App ID (or API Key), as it appears on the LinkedIn website.
         ACCOUNTS_EXTERN NSString * const ACLinkedInPermissionsKey NS_DEPRECATED(10_9, 10_13, NA, NA, "Use LinkedIn SDK instead");      // An array of of the LinkedIn permissions you're requesting.
         */
        
        let accountStore: ACAccountStore = ACAccountStore.init()
        let optionsLinkedIn = [ACLinkedInAppIdKey: "5007373",
                               ACLinkedInPermissionsKey: ["r_basicprofile"]] as [String : Any]
        let accountTypeLinkedIn: ACAccountType = accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierLinkedIn)

        accountStore.requestAccessToAccounts(with: accountTypeLinkedIn, options: optionsLinkedIn) { granted, error in

            if let error = error {
                debugPrint("Error connecting to LinkedIn: \(error)")
            }

            guard granted else {
                print("There are no LinkedIn accounts configured. You can add or create a LinkedIn account in Settings.")
                return
            }

            guard let linkedInAccounts = accountStore.accounts(with: accountTypeLinkedIn) , !linkedInAccounts.isEmpty else {
                print("There are no LinkedIn accounts configured. You can add or create a LinkedIn account in Settings.")
                return
            }

            let linkedInAccount = linkedInAccounts[0] as! ACAccount

        }
    }
}
