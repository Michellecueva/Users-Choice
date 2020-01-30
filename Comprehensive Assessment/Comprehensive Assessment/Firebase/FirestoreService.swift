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
    case favorites
}

enum FireBaseServiceError: Error {
    case unAuthorizedUser
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
 
    func getAccountType(completion: @escaping (Result<Any, Error>) -> ()) {
        guard let user = FirebaseAuthService.manager.currentUser else {
            fatalError()
        }
        
        let docRef = db.collection(FireStoreCollections.users.rawValue).document(user.uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let account = document["accountType"] else {
                    return
                }
                completion(.success(account))
            } else {
                  if let error = error {
                      completion(.failure(error))
                      print(error)
                  }
            }
        }

    }
    
    func updateAccountType(accountType: String, completion: @escaping (Result<(), Error>) -> ()) {
        guard let user = FirebaseAuthService.manager.currentUser else {
                   fatalError()
               }
        db.collection(FireStoreCollections.users.rawValue).document(user.uid).updateData(["accountType": accountType]) { (error) in
            if let error = error {
                completion(.failure(error))
                print(error)
            }
            completion(.success(()))
        }
        
    }
    //MARK: Favorite
    
    func createFavorite(favorite: Favorite, completion: @escaping (Result<(), Error>) -> ()) {
           var fields = favorite.fieldsDict
           fields["dateCreated"] = Date()
           db.collection(FireStoreCollections.favorites.rawValue).addDocument(data: fields) { (error) in
               if let error = error {
                   completion(.failure(error))
               } else {
                   completion(.success(()))
               }
           }
       }
    
    func removeFavorite(favorite: Favorite, completion: @escaping (Result<(), Error>) -> ()) {
        db.collection(FireStoreCollections.favorites.rawValue).document(favorite.id).delete() { err in
            if let err = err {
                completion(.failure(err))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func getFavorites(forUserID: String, accountType: String, completion: @escaping (Result<[Favorite], Error>) -> ()) {
        db.collection(FireStoreCollections.favorites.rawValue).whereField("creatorID", isEqualTo: forUserID).whereField("accountType", isEqualTo: accountType).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let favorites = snapshot?.documents.compactMap({ (snapshot) -> Favorite? in
                    let favoriteID = snapshot.documentID
                    let favorites = Favorite(from: snapshot.data(), id: favoriteID)
                    return favorites
                })
                completion(.success(favorites ?? []))
            }
        }
        
    }
}
