//
//  FirestoreService.swift
//  Comprehensive Assessment
//
//  Created by Michelle Cueva on 12/2/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import Foundation
import FirebaseFirestore

fileprivate enum FireStoreCollections: String {
    case users
    case posts
}


class FirestoreService {
    static let manager = FirestoreService()
    
    private let db = Firestore.firestore()
    
    //MARK: AppUsers
    func createAppUser(user: AppUser, completion: @escaping (Result<(), Error>) -> ()) {
        var fields = user.fieldsDict
        fields["dateCreated"] = Date()
        db.collection(FireStoreCollections.users.rawValue).document(user.uid).setData(fields) { (error) in
            if let error = error {
                completion(.failure(error))
                print(error)
            }
            completion(.success(()))
        }
    }
 
    
    //MARK: Posts
    
//    func createPost(post: Post, completion: @escaping (Result<(), Error>) -> ()) {
//           var fields = post.fieldsDict
//           fields["dateCreated"] = Date()
//           db.collection(FireStoreCollections.posts.rawValue).addDocument(data: fields) { (error) in
//               if let error = error {
//                   completion(.failure(error))
//               } else {
//                   completion(.success(()))
//               }
//           }
//       }
//       
//       func getAllPosts(completion: @escaping (Result<[Post], Error>) -> ()) {
//           let completionHandler: FIRQuerySnapshotBlock = {(snapshot, error) in
//               if let error = error {
//                   completion(.failure(error))
//               } else {
//                   let posts = snapshot?.documents.compactMap({ (snapshot) -> Post? in
//                       let postID = snapshot.documentID
//                       let post = Post(from: snapshot.data(), id: postID)
//                       return post
//                   })
//                   completion(.success(posts ?? []))
//               }
//           }
//
//           //type: Collection Reference
//           let collection = db.collection(FireStoreCollections.posts.rawValue)
//         
//         
//            let query = collection.order(by:"dateCreated", descending: true)
//               query.getDocuments(completion: completionHandler)
//
//       }
}
