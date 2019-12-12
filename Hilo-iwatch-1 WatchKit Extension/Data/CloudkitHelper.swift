//
//  CloudkitHelper.swift
//  Hilo-iwatch-1 WatchKit Extension
//
//  Created by ZHONG Sailin on 09.12.19.
//  Copyright © 2019 ZHONG Sailin. All rights reserved.
//

import Foundation
import CloudKit
import SwiftUI

struct CloudKitHelper {
    
    // MARK: - errors
    enum CloudKitHelperError: Error {
        case recordFailure
        case recordIDFailure
        case castFailure
        case cursorFailure
    }
    
    
    // MARK: - fetching from CloudKit
    static func fetch(completion: @escaping (Result<UserReaction, Error>) -> ()) {
        let pred = NSPredicate(value: true)
        let query = CKQuery(recordType: "UserReaction", predicate: pred)

        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["isP0UserReacted", "isP1UserReacted", "isP2UserReacted"]
        operation.resultsLimit = 1
        
        operation.recordFetchedBlock = { record in
            DispatchQueue.main.async {
//                let recordID = record.recordID
                let p0Reaction = record["isP0UserReacted"] as? Int64
                let p1Reaction = record["isP1UserReacted"] as? Int64
                let p2Reaction = record["isP2UserReacted"] as? Int64
//                let userReaction = UserReaction(recordID: recordID, p0UserReaction: p0Reaction, p1UserReaction: p1Reaction, p2UserReaction: p2Reaction)
                let userReaction = UserReaction(p0UserReaction: p0Reaction!, p1UserReaction: p1Reaction!, p2UserReaction: p2Reaction!)
                completion(.success(userReaction))
            }
        }
        
        operation.queryCompletionBlock = { (/*cursor*/ _, err) in
            DispatchQueue.main.async {
                if let err = err {
                    completion(.failure(err))
                    return
                }
            }
            
        }
        
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
}

