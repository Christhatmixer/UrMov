//
//  AppDelegate.swift
//  Urmove
//
//  Created by Christian on 5/5/18.
//  Copyright © 2018 ADNAP. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift
import FBSDKLoginKit
import FBSDKCoreKit
import TwitterKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var userData = customer()
    var userAccount: Bool?
    var userCollection: CollectionReference!
    var userRef: DocumentReference!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GMSServices.provideAPIKey("AIzaSyALoLhshrdNCqCEmOZvD-SfMmmMH7VVGe8")
        GMSPlacesClient.provideAPIKey("AIzaSyALoLhshrdNCqCEmOZvD-SfMmmMH7VVGe8")
        IQKeyboardManager.shared.enable = true
        //var navigationBarAppearance = UINavigationBar.appearance()
        //navigationBarAppearance.tintColor = UIColor.init(red: 255.0, green: 174.0, blue: 66.0, alpha: 1.0)
         FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user{
                self.getCars(userID: user.uid)
                let db = Firestore.firestore()
                self.userRef = db.collection("users").document(user.uid)
                self.userCollection = db.collection("users")
                self.userRef.getDocument { (document, error) in
                    
                    if (document?.exists)!{
                        //self.userAccount = true
                        self.userAccount = true
                        
                        let loggedInUserData = customer()
                        let dict = document?.data()
                        let email = dict!["email"] as? String
                        let firstName = dict!["firstName"] as? String
                        let lastName = dict!["lastName"] as? String
                        let authenticated = dict!["authenticated"] as? Bool
                        let phoneNumber = dict!["phoneNumber"] as? String
                        let userID = dict!["userID"] as? String
                        
                        self.userData.email = email
                        self.userData.firstName = firstName
                        self.userData.lastName = lastName
                        self.userData.authenticated = authenticated
                        self.userData.phoneNumber = phoneNumber
                        self.userData.userID = userID
                        self.getCars(userID: user.uid)
                        print(self.userData.authenticated!)
                        if self.userData.authenticated! == false{
                            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "phoneVerification") as! PhoneVerificationViewController
                            vc.userData = self.userData
                            let navigation = UINavigationController(rootViewController: vc)
                            navigation.navigationBar.isTranslucent = false
                            navigation.navigationBar.barTintColor = UIColor(displayP3Red: 40.0/250, green: 39.0/250, blue: 46.0/250, alpha: 1.0)
                            navigation.navigationBar.tintColor = UIColor(displayP3Red: 245.0/250, green: 174.0/250, blue: 66.0/250, alpha: 1.0)
                            navigation.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(displayP3Red: 243.0/250, green: 245.0/250, blue: 246.0/250, alpha: 1.0)]
                            navigation.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(displayP3Red: 243.0/250, green: 245.0/250, blue: 246.0/250, alpha: 1.0)]
                            self.window?.rootViewController = navigation
                            self.window?.makeKeyAndVisible()
                        }else{
                            
                            
                            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "carSelection") as! CarSelectionViewController
                            vc.userData = self.userData
                            let navigation = UINavigationController(rootViewController: vc)
                            navigation.navigationBar.isTranslucent = false
                            navigation.navigationBar.barTintColor = UIColor(displayP3Red: 40.0/250, green: 39.0/250, blue: 46.0/250, alpha: 1.0)
                            navigation.navigationBar.tintColor = UIColor(displayP3Red: 245.0/250, green: 174.0/250, blue: 66.0/250, alpha: 1.0)
                            navigation.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(displayP3Red: 243.0/250, green: 245.0/250, blue: 246.0/250, alpha: 1.0)]
                            navigation.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(displayP3Red: 243.0/250, green: 245.0/250, blue: 246.0/250, alpha: 1.0)]
                            self.window?.rootViewController = navigation
                            self.window?.makeKeyAndVisible()
                            //let navigation = UINavigationController(rootViewController: vc)
                            //self.present(navigation, animated: true, completion: nil)
                            
                        }
                        
                       
                        
                        
                    }
                }
                
            }
            
            
        }
        return true
    }
    func getCars(userID: String){
        let userCarCollection = Firestore.firestore().collection("users").document(userID).collection("cars")
        userCarCollection.getDocuments { (snapshot, error) in
            if let error = error{
                print(error)
            }else{
                for document in snapshot!.documents{
                    let newCar = car()
                    let dict = document.data()
                    let model = dict["model"] as? String
                    let year = dict["year"] as? String
                    let make = dict["make"] as? String
                    let color = dict["color"] as? String
                    let tag = dict["tag"] as? String
                    let fuelCapacity = dict["fuelCapacity"] as? Double
                    newCar.color = color
                    newCar.make = make
                    newCar.model = model
                    newCar.tag = tag
                    newCar.year = year
                    newCar.fuelCapacity = fuelCapacity
                    self.userData.carList.append(newCar)
                    
                }
                print(self.userData.carList)
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if TWTRTwitter.sharedInstance().application(app, open: url, options: options){
            return true
        }else{
            return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation] ?? [])
        }
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Urmove")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

